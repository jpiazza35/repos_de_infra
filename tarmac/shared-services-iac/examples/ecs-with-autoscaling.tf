module "ecs_scaling" {
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
      task_role_arn              = ""
      ephemeral_storage = [
        {
          size_in_gib = 20
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
        },

      ]
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
    log_retention_in_days = 90
  }

  ## ECS Tags Config
  tags = {
    Environment = "dev"
    App         = "ecs-complete"
    Resource    = "Managed by Terraform"
    Description = "ALB Related Configuration"
    Team        = "Devops"
  }
}

