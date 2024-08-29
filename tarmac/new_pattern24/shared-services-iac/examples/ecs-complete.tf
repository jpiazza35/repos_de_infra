module "ecs_complete" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//ecs?ref=v1.0.0"

  ## ECS Cluster Config
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

  ## ECS Service Config
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
      load_balancer = [
        {
          target_group_arn = module.alb.target_group_arn
          container_name   = "nginx"
          container_port   = 80
        }
      ]
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
      task_cpu                   = 256
      task_memory                = 512
      task_role_arn              = ""
      ephemeral_storage = [
        {
          size_in_gib = 21
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
              name  = "TESTING",
              value = "yup"
            },
            {
              name  = "AGAIN"
              value = "nope"
            }
          ]
          environment_files = []
          health_check_command = [
            "CMD-SHELL",
            "curl localhost:80/healthz"
          ]
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
    egress = [
      {
        description = "test"
        from_port   = 0
        to_port     = 65535
        protocol    = "-1"
        cidr_blocks = [
          "10.0.0.0/32"
        ]
      }
    ]
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

module "acm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm?ref=v1.0.0"
  providers = {
    aws = aws
  }
  env         = "dev"
  dns_zone_id = ""
  dns_name    = "cliniciannexus.com"
  san = [
    "example"
  ]                       ## list of domain names that should be added to the certificate, if left blank only a wildcard cert will be created
  create_wildcard = false ## Should a wildcard certificate be created, if omitted, you must specify value(s) for the `san` variable
  tags = merge(
    /* var.tags, */
    {
      Environment = "dev"
      App         = "ecs" ## Application/Product the DNS is for e.g. ecs, argocd
      Resource    = "Managed by Terraform"
      Description = "DNS Related Configuration"
      Team        = "DevOps" ## Name of the team requesting the creation of the DNS resource
    }
  )
}

module "acm_validation" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm_validation?ref=v1.0.0"
  providers = {
    aws.ss_network = aws.ss_network
  }
  depends_on = [
    module.acm
  ]
  env         = "dev"
  dns_name    = "cliniciannexus.com"
  dns_zone_id = ""
  cert        = module.acm.cert
}

module "alb" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//alb?ref=v1.0.0"
  alb = {
    app                   = "alb"
    env                   = "dev"
    team                  = "devops"
    load_balancer_type    = "application" # application | network
    internal              = true
    create_security_group = true
    access_logs = {
      bucket  = ""
      prefix  = "example"
      enabled = true
    }
    security_group = {
      ids = []
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
      ]
      egress = [
        {
          description = "test"
          from_port   = 0
          to_port     = 65535
          protocol    = "-1"
          cidr_blocks = [
            "10.0.0.0/32"
          ]
        },
      ]
    }
    enable_deletion_protection = false
    listeners = [
      {
        port        = "80"
        protocol    = "HTTP"
        action_type = "redirect" # redirect | fixed_response
      },
      {
        port        = "443"
        protocol    = "HTTPS"
        acm_arn     = module.acm.arn
        action_type = "forward" # redirect | forward | fixed_response
      }
    ]
    default_actions = {
      redirect = {
        create      = true
        port        = 443
        type        = "redirect"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    target_groups = [
      {
        name_prefix                        = "tg"
        protocol                           = "HTTP"
        port                               = 80
        deregistration_delay               = 300
        target_type                        = "ip"                              # ip | instance | lambda | alb
        load_balancing_cross_zone_enabled  = "use_load_balancer_configuration" # "true" | "false" | "use_load_balancer_configuration"
        lambda_multi_value_headers_enabled = false
        protocol_version                   = "HTTP1" #HTTP1 | HTTP2 | GRPC
        health_check = {
          enabled             = true
          healthy_threshold   = 2
          interval            = 5
          matcher             = "200,302"
          path                = "/"
          port                = 443
          protocol            = "HTTPS"
          timeout             = 2
          unhealthy_threshold = 2
        }
      }
    ]
    tags = {
      Environment = "dev"
      App         = "alb"
      Resource    = "Managed by Terraform"
      Description = "ALB Related Configuration"
      Team        = "Devops"
    }
  }
}


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias   = "ss_network"
  profile = "ss_network"
}
