module "ecr" {
  source = "../terraform/modules/ecr"

  app  = var.app
  env  = var.env
  tags = var.tags
}

module "ecs" {
  source = "../terraform/modules/ecs"

  ## ECS Cluster Config
  cluster = {
    app         = var.app # replace all vars
    env         = var.env
    team        = "Devops"
    name_prefix = "github-runner"
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

  ## ECS Service Config
  ecs_service = [
    {
      desired_count                      = 3
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


  ## ECS Task config
  ecs_task = [
    {
      requires_compatilibilities = ["FARGATE"]
      task_cpu                   = 2048
      task_memory                = 6144
      task_role_arn              = ""
      ephemeral_storage = [
        {
          size_in_gib = 21
        }
      ]
      container_task_definitions = [
        {
          task_name             = "github-runner"
          image_url             = format("%s.dkr.ecr.%s.amazonaws.com/%s-ecr-repo:%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name, var.app, var.ecr_image_tag)
          cpu                   = 1024
          memory                = 3072
          container_port        = 80
          container_host_port   = 80
          essential             = true
          command               = []
          environment_variables = [] # Add environment variables if needed
          health_check_command  = ["CMD-SHELL", "echo 'up'"]
          health_check_interval = 15
          health_check_timeout  = 5
          health_check_retries  = 2
          mount_points          = []
          volumes_from          = []
          depends_on            = []
          working_dir           = ""
          log_driver            = "awslogs"
          awslogs_create_group  = "true"
          awslogs_group_path    = "/ecs/"
          region                = data.aws_region.current.name
          log_stream_prefix     = "github-runner"
          secrets = [
            {
              name      = "TOKEN"
              valueFrom = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:github-runner-uipJMG:token:AWSCURRENT:"
            }
          ]
        }
      ]
      placement_constraints = []
      runtime_platform = {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
      }
    }
  ]

  ## ECS Application Autoscaling Config
  autoscaling = {
    enabled = true
    target = {
      max_capacity       = 9
      min_capacity       = 3
      scalable_dimension = "ecs:service:DesiredCount"
      service_namespace  = "ecs"
    }
    policy = {
      policy_type = "TargetTrackingScaling"
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
          }
        }
      ]
    }
  }

  ## ECS Security Group Config
  security_group = {
    ingress = []
    egress  = []
  }


  ## ECS Cloudwatch Logging Config
  cloudwatch_log_group = {
    log_retention_in_days = 30
  }

  ## ECS Tags Config
  tags = var.tags
}
