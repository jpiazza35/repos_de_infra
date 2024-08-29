variable "env" {
  description = "Environment"
  type        = string
}
variable "app" {
  description = "Application"
  type        = string
}
variable "tags" {
  description = "Tags"
  type        = map(any)
}
variable "data_dot_world_aws_account_id" {
  description = "data_dot_world AWS Account ID"
  type        = string
}

variable "profile" {
  description = "Profile for p_data_platform"
  default     = "p_data_platform"
}

variable "region" {
  description = "Region"
  default     = "us-east-1"
}
# variable "lambda" {
#   description = "Lambda"
#   type = object({
#     function_name        = string
#     description          = string
#     handler              = string
#     runtime_version      = string
#     architectures        = string
#     timeout              = number
#     memory_size          = number
#     ephemeral_storage    = number
#     requirementsfilename = string
#     codefilename         = string
#     working_dir          = string
#     variables            = map(string)
#   })
# }

variable "target_db_instance_ids" {
  description = "List the db_instances ids that will trigger the lambda function"
  type        = list(string)
}

variable "data_dot_world_cidr" {
  description = "Fivetran CIDR"
  type        = string
}

variable "routes" {
  type = map(object({
    listener = object({
      port             = string
      protocol         = string
      acm_arn          = optional(string)
      target_group_arn = optional(string)
      action_type      = string
      tags             = optional(map(any))
    })
    target_group = object({
      name_prefix                        = string
      vpc_id                             = optional(string)
      protocol                           = string
      port                               = number
      deregistration_delay               = number
      target_type                        = string
      load_balancing_cross_zone_enabled  = string
      lambda_multi_value_headers_enabled = bool
      protocol_version                   = string
      health_check = object({
        enabled             = bool
        healthy_threshold   = number
        interval            = number
        matcher             = string
        path                = string
        port                = number
        protocol            = string
        timeout             = number
        unhealthy_threshold = number
      })
      tags = optional(map(any))
    })
  }))
}
