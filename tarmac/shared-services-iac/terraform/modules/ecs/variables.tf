variable "cluster" {
  type = object({
    app         = string
    env         = string
    team        = string
    name_prefix = string
    settings = object({
      name  = string
      value = string
    })
    service_connect_defaults = optional(object({
      namespace = string
    }))
    configuration = optional(object({
      execute_command_configuration = list(object({
        kms_key_id = string
        logging    = optional(string, "DEFAULT")
        log_configuration = object({
          cloud_watch_encryption_enabled = bool
          cloud_watch_log_group_name     = string
          s3_bucket_name                 = string
          s3_bucket_encryption_enabled   = bool
          s3_key_prefix                  = string
        })
      }))
    }))
  })
}

variable "capacity_providers" {
  type = map(object({
    provider = string
    base     = optional(number)
    weight   = number
  }))
  default = {
    "FARGATE_SPOT" = {
      provider = "FARGATE_SPOT"
      weight   = 100
    }
  }
}

variable "cloudwatch_log_group" {
  type = object({
    log_retention_in_days = optional(number)
    logs_kms_key          = optional(string)
  })
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "autoscaling" {
  type = object({
    enabled = bool
    target = optional(object({
      max_capacity       = number
      min_capacity       = number
      resource_id        = optional(string)
      scalable_dimension = optional(string)
      service_namespace  = optional(string)
    }))
    policy = optional(object({
      policy_type        = string
      scalable_dimension = optional(string)
      service_namespace  = optional(string)
      target_tracking_scaling_policy_configuration = optional(list(object({
        name               = string
        target_value       = number
        scale_in_cooldown  = number
        scale_out_cooldown = number
        predefined_metric_specification = object({
          predefined_metric_type = string
          resource_label         = optional(string)
        })
        customized_metric_specification = optional(object({
          metric_name = string
          namespace   = string
          statistic   = string
          unit        = string
          dimensions = list(object({
            name  = string
            value = string
          }))
          metrics = list(object({
            label       = string
            id          = string
            expression  = string
            return_data = bool
            metric_stat = object({
              metric = string
              stat   = string
              unit   = number
            })
          }))
        }))
      })))
      step_scaling_policy_configuration = optional(list(object({
        adjustment_type          = string
        cooldown                 = number
        metric_aggregation_type  = string
        min_adjustment_magnitude = number
        step_adjustment = list(object({
          metric_interval_lower_bound = number
          metric_interval_upper_bound = number
          scaling_adjustment          = number
        }))
      })))
    }))
  })
}

variable "ecs_task" {
  type = list(object({
    family                     = optional(string)
    ipc_mode                   = optional(string)
    pid_mode                   = optional(string)
    execution_role_arn         = optional(string)
    network_mode               = optional(string)
    requires_compatilibilities = list(string)
    task_cpu                   = number
    task_memory                = number
    task_role_arn              = optional(string)
    ephemeral_storage = list(object({
      size_in_gib = optional(number, 21)
    }))
    container_task_definitions = optional(list(object({
      task_name           = string
      image_url           = string
      cpu                 = number
      memory              = number
      container_port      = number
      container_host_port = number
      essential           = bool
      command             = optional(list(string))
      environment_variables = optional(list(object({
        name  = optional(string)
        value = optional(string)
      })))
      environment_files = optional(list(object({
        type  = optional(string)
        value = optional(string)
        name  = string
      })))
      health_check_command  = list(string)
      health_check_interval = number
      health_check_timeout  = number
      health_check_retries  = number
      mount_points = optional(list(object({
        containerPath = optional(string)
        readOnly      = optional(bool)
        sourceVolume  = optional(string)
      })))
      volumes_from = optional(list(object({
        readOnly        = optional(bool)
        sourceContainer = optional(string)
      })))
      depends_on = optional(list(object({
        condition     = optional(string)
        containerName = optional(string)
      })))
      working_dir          = string
      log_driver           = string
      awslogs_create_group = string
      awslogs_group_path   = string
      region               = string
      log_stream_prefix    = string
      secrets = optional(list(object({
        name      = optional(string)
        valueFrom = optional(string)
      })))
      }
    )))
    inference_accelerator = optional(object({
      device_name = string
      device_type = string
    }))
    volume = optional(list(object({
      name      = string
      host_path = string
      docker_volume_configuration = optional(list(object({
        scope         = string
        autoprovision = bool
        driver        = string
        driver_opts   = map(string)
        labels        = map(string)
      })))
      efs_volume_configuration = optional(list(object({
        file_system_id          = string
        root_directory          = string
        transit_encryption      = string
        transit_encryption_port = number
      })))
      authorization_config = optional(list(object({
        access_point_id = string
        iam             = string
      })))
    })))
    runtime_platform = optional(object({
      operating_system_family = string
      cpu_architecture        = string
    }))
    placement_constraints = optional(list(object({
      expression = string
      type       = string
    })))
    proxy_configuration = optional(object({
      container_name = string
      properties     = map(string)
      type           = string
    }))
    task_definitions = optional(any)
  }))
}

variable "security_group" {
  type = object({
    vpc_id = optional(string)
    ingress = optional(list(object({
      description = optional(string)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })))
    egress = optional(list(object({
      description = optional(string)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })))
  })
}

variable "ecs_service" {
  type = list(object({
    desired_count                      = number
    propagate_tags                     = optional(string, "SERVICE")
    platform_version                   = optional(string)
    launch_type                        = optional(string, "FARGATE")
    force_new_deployment               = optional(bool, false)
    wait_for_steady_state              = optional(bool, true)
    enable_execute_command             = optional(bool, true)
    enable_ecs_managed_tags            = optional(bool, true)
    deployment_minimum_healthy_percent = optional(number, 75)
    deployment_maximum_percent         = optional(number, 200)
    health_check_grace_period_seconds  = optional(number, 60)
    alarms = optional(list(object({
      alarm_names = list(string)
      enable      = bool
      rollback    = bool
    })))
    network_configuration = optional(object({
      subnets          = list(string)
      security_groups  = list(string)
      assign_public_ip = bool
    }))
    capacity_provider_strategy = optional(object({
      capacity_provider = string
      weight            = number
      base              = number
    }))
    deployment_circuit_breaker = optional(object({
      enable   = bool
      rollback = bool
    }))
    deployment_controller = optional(object({
      type = string
    }))
    load_balancer = optional(list(object({
      container_name   = string
      container_port   = number
      target_group_arn = optional(string)
      elb_name         = optional(string)
    })))
    ordered_placement_strategy = optional(object({
      type  = string
      field = string
    }))
    placement_constraints = optional(object({
      type       = string
      expression = string
    }))
    service_connect_configuration = optional(object({
      enabled           = bool
      log_configuration = string
      namespace         = string
      service = optional(object({
        client_alias = optional(object({
          dns_name = optional(string)
          port     = number
        }))
        discovery_name        = string
        ingress_port_override = number
        port_name             = string

      }))
      log_configuration = optional(object({
        log_driver = string
        options    = map(string)
        secret_option = optional(object({
          name       = string
          value_from = string
        }))
      }))
    }))
    service_registries = optional(object({
      registry_arn   = string
      port           = number
      container_port = number
      container_name = string
    }))
    task_definition = optional(string)
    triggers        = optional(map(string))
  }))
}
