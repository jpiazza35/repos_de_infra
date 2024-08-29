module "ecs_prebuilt" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//ecs?ref=v1.0.0"

  ## Cluster Config
  cluster = {
    app         = "ecs-complete"
    env         = "dev"
    team        = "Devops"
    name_prefix = "example"
    settings = {
      name  = "containerInsights"
      value = "enabled"
    }
  }

  ## ECS Capacity Providers Config
  capacity_providers = {
    FARGATE_SPOT = {
      provider = "FARGATE_SPOT"
      weight   = 100
    }
  }

  ## Service Config
  ecs_service = [
    {
      desired_count                      = 2
      propagate_tags                     = "SERVICE"
      launch_type                        = "FARGATE"
      force_new_deployment               = false
      wait_for_steady_state              = true
      deployment_minimum_healthy_percent = 90
      deployment_maximum_percent         = 200
      health_check_grace_period_seconds  = 60
      deployment_controller = {
        type = "ECS"
      }
      deployment_circuit_breaker = {
        enable   = false
        rollback = false
      }
      service_connect_configuration = {
        enabled   = false
        namespace = ""
      }
    }
  ]

  ## Task config
  ecs_task = [
    {
      requires_compatilibilities = ["FARGATE"]
      task_cpu                   = 256
      task_memory                = 512
      ephemeral_storage = [
        {
          size_in_gib = 21
        }
      ]
      placement_constraints = []
      runtime_platform = {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
      }
      container_task_definitions = []
      task_definitions           = <<DEFINITION
[
  {
    "name" : "test",
    "image" : "000000000000000.dkr.ecr.us-east-1.amazonaws.com/test:latest",
    "cpu" : 0,
    "portMappings" : [
      {
        "name" : "test-3000-tcp",
        "containerPort" : 3000,
        "hostPort" : 3000,
        "protocol" : "tcp",
        "appProtocol" : "http"
      }
    ],
    "essential" : true,
    "command" : [
      "./wait-for-it.sh",
      "localhost:5432",
      "--",
      "python3",
      "main.py"
    ],
    "environment" : [
      {
        "name" : "POSTGRES_USER",
        "value" : "admin"
      }
    ],
    "environmentFiles" : [
      {
        "value" : "arn:aws:s3:::example2-s3/.env",
        "type" : "s3"
      }
    ],
    "mountPoints" : [],
    "volumesFrom" : [],
    "dependsOn" : [
      {
        "containerName" : "db",
        "condition" : "HEALTHY"
      }
    ],
    "workingDirectory" : "/test",
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-create-group" : "true",
        "awslogs-group" : "/ecs/",
        "awslogs-region" : "us-east-1",
        "awslogs-stream-prefix" : "ecs"
      }
    }
  },
  {
    "name" : "db",
    "image" : "postgres:15",
    "cpu" : 0,
    "portMappings" : [
      {
        "name" : "db-5432-tcp",
        "containerPort" : 5432,
        "hostPort" : 5432,
        "protocol" : "tcp",
        "appProtocol" : "http"
      }
    ],
    "essential" : true,
    "command" : [
      "postgres",
      "-c",
      "log_statement=all",
      "-c",
      "log_destination=stderr"
    ],
    "environment" : [
      {
        "name" : "POSTGRES_USER",
        "value" : "admin"
      },
      {
        "name" : "POSTGRES_PASSWORD",
        "value" : "ecs-sample"
      },
      {
        "name" : "POSTGRES_DB",
        "value" : "ecs"
      }
    ],
    "mountPoints" : [],
    "volumesFrom" : [],
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-create-group" : "true",
        "awslogs-group" : "/ecs/test",
        "awslogs-region" : "us-east-1",
        "awslogs-stream-prefix" : "ecs"
      }
    },
    "healthCheck" : {
      "command" : [
        "CMD-SHELL",
        "pg_isready"
      ],
      "interval" : 30,
      "timeout" : 5,
      "retries" : 3
    }
  }
] 
DEFINITION
    }
  ]

  ## ECS Application Autoscaling Config
  autoscaling = {
    enabled = false
  }

  security_group = {
    ingress = [
      {
        description = "test"
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        cidr_blocks = [
          "10.0.0.0/32"
        ]
      }
    ]
    egress = []
  }

  cloudwatch_log_group = {
    log_retention_in_days = 90
  }

  tags = {
    Environment = "dev"
    App         = "ecs-complete"
    Resource    = "Managed by Terraform"
    Description = "ALB Related Configuration"
    Team        = "Devops"
  }
}

