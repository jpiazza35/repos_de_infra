variable "region" {
  default = "us-east-1"
}

variable "agent_properties" {
  type = map(object({
    name = string
    ecr = object({
      image_tag_mutability = string
      image_scanning = object({
        scan_on_push = bool
      })
      lifecycle_policy = object({
        description            = string
        action_type            = string
        selection_tag_status   = string
        selection_count_type   = string
        selection_count_number = number
      })
    })
    ecs = object({
      containerinsights_enable = string
      security_group_rules = object({
        egress = list(object({
          from_port   = number
          to_port     = number
          protocol    = string
          cidr_blocks = list(string)
          self        = bool
        }))
        ingress = list(object({
          from_port   = number
          to_port     = number
          protocol    = string
          cidr_blocks = list(string)
          self        = bool
        }))
      })
      services = map(object({
        service                = string
        name                   = string
        cpu                    = number
        memory                 = number
        max_capacity           = number
        min_capacity           = number
        desired_count          = number
        enable_execute_command = bool
        taskDefinitionValues = object({
          image_tag      = string
          container_name = string
          container_port = number
          host_port      = number
          awslogs-region = string
          awslogs-group  = string
          portMappings   = string
        })
      }))
    })
  }))
}


variable "common_properties" {
  type = object({
    vpc_id      = string
    environment = string
    env_prefix  = string
    product     = string
  })
}

variable "lambda_properties" {
  type = object({
    function_name     = string
    description       = string
    handler           = string
    architectures     = string
    runtime_version   = string
    timeout           = number
    memory_size       = number
    ephemeral_storage = number
  })
}
