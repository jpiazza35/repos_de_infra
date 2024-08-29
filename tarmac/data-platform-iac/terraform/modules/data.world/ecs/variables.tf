variable "properties" {
  type = object({
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
    vpc_id                = string
    environment           = string
    env_prefix            = string
    product               = string
    container_definitions = string
    private_subnets       = list(string)
    list_email_address    = list(string)
    slack                 = any
    guardrail_policies    = any
  })
}

variable "aws_s3_collector_bucket" {
  description = "S3 Bucket name for collecting metadata"
}

variable "aws_s3_collector_iam_role" {
  description = "Cross account assume iam role for S3 collector"
}
