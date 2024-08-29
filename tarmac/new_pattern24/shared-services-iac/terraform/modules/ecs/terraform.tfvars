cluster = {
  app         = "ecs"
  env         = "dev"
  team        = "Devops"
  name_prefix = "sample"
  settings = {
    name  = "containerInsights"
    value = "disabled"
  }
  service_connect_defaults = {
    namespace = ""
  }
  configuration = {
    execute_command_configuration = [
      {
        kms_key_id = ""
        logging    = "DEFAULT" # "NONE" | "DEFAULT" | "OVERRIDE"
        log_configuration = {
          cloud_watch_encryption_enabled = false
          cloud_watch_log_group_name     = ""
          s3_bucket_name                 = ""
          s3_bucket_encryption_enabled   = true
          s3_key_prefix                  = ""
        }
      }
    ]
  }
}

capacity_providers = {
  FARGATE = {
    provider = ""
    base     = null
    weight   = null
  }
  FARGATE_SPOT = {
    provider = "FARGATE_SPOT"
    base     = null
    weight   = 100
  }
}

ecs_service = [
  {
    desired_count                      = 1
    propagate_tags                     = "NONE" # NONE | SERVICE | TASK_DEFINITION
    launch_type                        = "FARGATE"
    platform_version                   = ""
    force_new_deployment               = false
    wait_for_steady_state              = true
    enable_execute_command             = true
    enable_ecs_managed_tags            = true
    deployment_minimum_healthy_percent = null
    deployment_maximum_percent         = null
    health_check_grace_period_seconds  = null
    alarms = [
      {
        alarm_names = []
        enable      = false
        rollback    = false
      }
    ]
    network_configuration = {
      subnets          = []
      security_groups  = []
      assign_public_ip = false
    }
    capacity_provider_strategy = {
      capacity_provider = ""
      weight            = null
      base              = null
    }
    deployment_circuit_breaker = {
      enable   = false
      rollback = false
    }
    deployment_controller = {
      type = "ECS"
    }
    load_balancer = null
    /* [
      {
          container_name   = ""
          container_port   = null
          target_group_arn = ""
          elb_name         = ""
        }
    ] */
    ordered_placement_strategy = null
    /* {
        type  = ""
        field = ""
      } */
    placement_constraints = null
    /* {
        type       = ""
        expression = ""
      } */
    service_connect_configuration = {
      enabled           = false
      log_configuration = {}
      namespace         = ""
      service = {
        client_alias = {
          dns_name = ""
          port     = null
        }
        discovery_name        = ""
        ingress_port_override = null
        port_name             = ""

      }
      log_configuration = {
        log_driver = ""
        options    = {}
        secret_option = {
          name       = ""
          value_from = ""
        }
      }
    }
    service_registries = {
      registry_arn   = ""
      port           = null
      container_port = null
      container_name = ""
    }
    task_definition = ""
    triggers        = {}
  }
]

ecs_task = [
  {
    family                     = null
    ipc_mode                   = null
    pid_mode                   = null
    execution_role_arn         = ""
    network_mode               = ""
    requires_compatilibilities = []
    task_cpu                   = null
    task_memory                = null
    task_role_arn              = ""
    ephemeral_storage = [
      {
        size_in_gib = null
      }
    ]
    container_task_definitions = [
      {
        task_name           = "nginx"
        image_url           = "nginx:latest"
        cpu                 = 128
        memory              = 256
        container_port      = 80
        container_host_port = 80
        essential           = true # true | false
        command = [
          "/bin/bash",
          "-c",
          "pwd"
        ]
        environment_variables = [
          {
            name  = "TEST",
            value = "yup"
          },
          {
            name  = "again"
            value = "nope"
          }
        ]
        environment_files = []
        health_check_command = [
          "CMD-SHELL",
          "curl localhost:80/health"
        ]
        health_check_interval = 5
        health_check_timeout  = 5
        health_check_retries  = 2
        mount_points          = []
        volumes_from          = []
        depends_on            = []
        working_dir           = ""
        log_driver            = "awslogs"
        awslogs_create_group  = "true"
        awslogs_group_path    = "/ecs/"
        region                = ""
        log_stream_prefix     = "nginx"
        secrets = [
          /* {
            name = ""
            valueFrom = ""
          } */
        ]
      },
      {
        task_name           = "example"
        image_url           = "nginx:latest"
        cpu                 = 128
        memory              = 256
        container_port      = 3000
        container_host_port = 3000
        essential           = true # true | false
        command = [
          "/bin/bash",
          "-c",
          "pwd"
        ]
        environment_variables = [
          {
            name  = "TEST",
            value = "yup"
          },
          {
            name  = "again"
            value = "nope"
          }
        ]
        environment_files = [
          {
            name  = "example1" ## The name is required when specifying environment environmentFiles
            type  = "S3"
            value = "arn:aws:s3:::example-s3/.env"
          }
        ]
        health_check_command = [
          "CMD-SHELL",
          "curl localhost:80/health"
        ]
        health_check_interval = 5
        health_check_timeout  = 5
        health_check_retries  = 2
        mount_points = [
          {
            source_volume  = "example"
            container_path = "/test"
            read_only      = false
          }
        ]
        volumes_from = [
          {
            source_container = "example"
            read_only        = false
          }
        ]
        depends_on = [
          {
            container_name = "nginx"
            condition      = "HEALTHY"
          }
        ]
        working_dir          = ""
        log_driver           = "awslogs"
        awslogs_create_group = "true"
        awslogs_group_path   = "/ecs/"
        region               = ""
        log_stream_prefix    = "example"
        secrets = [
          /* {
            name = ""
            valueFrom = ""
          } */
        ]
      },

    ]
    inference_accelerator = null
    volume                = []
    runtime_platform = {
      operating_system_family = "LINUX"
      cpu_architecture        = "X86_64"
    }
    placement_constraints = []
    proxy_configuration   = null
    task_definitions      = null
    /* <<DEFINITION
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
DEFINITION */
  }
]

autoscaling = {
  enabled = false
  target = {
    max_capacity       = 9
    min_capacity       = 3
    resource_id        = ""
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace  = "ecs"
  }
  policy = {
    policy_type        = "TargetTrackingScaling"
    scalable_dimension = ""
    service_namespace  = ""
    target_tracking_scaling_policy_configuration = [
      {
        name               = "cpu"
        target_value       = 60
        scale_in_cooldown  = 300
        scale_out_cooldown = 300
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageCPUUtilization"
          resource_label         = ""
        }
      },
      {
        name               = "memory"
        target_value       = 80
        scale_in_cooldown  = 300
        scale_out_cooldown = 300
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageMemoryUtilization"
          resource_label         = ""
        }
      }
    ]
    customized_metric_specification = {
      /*  metric_name = ""
      namespace   = ""
      statistic   = ""
      unit        = ""
      dimensions = [
        {
          name  = ""
          value = ""
        }
      ]
      metrics = [
        {
          label       = ""
          id          = ""
          expression  = ""
          return_data = false
          metric_stat = {
            metric = ""
            stat   = ""
            unit   = null
          }
        }
      ] */
    }
    step_scaling_policy_configuration = [
      /* {
        adjustment_type          = ""
        cooldown                 = null
        metric_aggregation_type  = ""
        min_adjustment_magnitude = null
        step_adjustment = [
          {
            metric_interval_lower_bound = null
            metric_interval_upper_bound = null
            scaling_adjustment          = null
          }
        ]
      } */
    ]
  }
}

security_group = {
  vpc_id = ""
  ingress = [
    {
      description = "test"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = [
        "10.0.0.0/32"
      ]
    },
    {
      description = ""
      from_port   = null
      to_port     = null
      protocol    = ""
      cidr_blocks = []
    },
  ]
  egress = [
    {
      description = ""
      from_port   = null
      to_port     = null
      protocol    = ""
      cidr_blocks = []
    },
    {
      description = ""
      from_port   = null
      to_port     = null
      protocol    = ""
      cidr_blocks = []
    },
  ]
}

tags = {
  Environment = "dev"
  App         = "alb"
  Resource    = "Managed by Terraform"
  Description = "ALB Related Configuration"
  Team        = "Devops"
}

cloudwatch_log_group = {
  log_retention_in_days = 90
  logs_kms_key          = ""
}
