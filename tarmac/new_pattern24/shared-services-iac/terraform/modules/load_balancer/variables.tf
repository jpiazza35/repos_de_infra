variable "lb" {
  type = object(
    {
      app                              = string
      env                              = string
      team                             = string
      load_balancer_type               = string
      internal                         = bool
      subnets                          = optional(list(string))
      create_security_group            = bool
      create_static_public_ip          = bool
      enable_cross_zone_load_balancing = optional(bool)
      security_group = object({
        ids = optional(list(string))
        ingress = optional(list(object({
          description = string
          from_port   = number
          to_port     = number
          protocol    = string
          cidr_blocks = list(string)
        })))
        egress = optional(list(object({
          description = string
          from_port   = number
          to_port     = number
          protocol    = string
          cidr_blocks = list(string)
        })))
      })
      enable_deletion_protection = optional(bool)
      access_logs = optional(object({
        bucket  = string
        prefix  = string
        enabled = bool
      }))
      vpc_id = optional(string)
      listeners = list(object({
        port             = string
        protocol         = string
        acm_arn          = optional(string)
        target_group_arn = optional(string)
        action_type      = string
      }))
      target_groups = list(object({
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
      }))
      tags = optional(map(any))
    }
  )
  default = {
    app                              = "lb"
    env                              = "dev"
    team                             = "devops"
    load_balancer_type               = "network"
    internal                         = true
    subnets                          = []
    create_security_group            = true
    create_static_public_ip          = false
    enable_cross_zone_load_balancing = false
    security_group = {
      ids     = []
      ingress = []
      /* [
        {
          description = ""
          from_port   = null
          to_port     = null
          protocol    = ""
          cidr_blocks = [
            "0.0.0.0/32"
          ]
        },
        {
          description = ""
          from_port   = null
          to_port     = null
          protocol    = ""
          cidr_blocks = [
            "0.0.0.0/32"
          ]
        },
      ] */
      egress = []
      /* [
        {
          description = ""
          from_port   = null
          to_port     = null
          protocol    = ""
          cidr_blocks = [
            "0.0.0.0/32"
          ]
        },
        {
          description = ""
          from_port   = null
          to_port     = null
          protocol    = ""
          cidr_blocks = [
            "0.0.0.0/32"
          ]
        },
      ] */
    }
    enable_deletion_protection = false
    access_logs = {
      bucket  = ""
      prefix  = ""
      enabled = false
    }
    vpc_id = ""
    listeners = [
      {
        port             = "80"
        protocol         = "HTTP"
        acm_arn          = null
        target_group_arn = ""
        action_type      = "redirect"
      },
      {
        port             = "80"
        protocol         = "HTTP"
        acm_arn          = null
        target_group_arn = ""
        action_type      = "fixed_response"
      },
      {
        port             = "80"
        protocol         = "HTTP"
        acm_arn          = null
        target_group_arn = ""
        action_type      = "default"
      },
    ]
    target_groups = [
      {
        name_prefix                        = "tg"
        vpc_id                             = ""
        protocol                           = "HTTP"
        port                               = 80
        deregistration_delay               = 300
        target_type                        = "ip"
        load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
        lambda_multi_value_headers_enabled = false
        protocol_version                   = "HTTP1"
        health_check = {
          enabled             = true
          healthy_threshold   = 2
          interval            = 5
          matcher             = "200,302"
          path                = "/"
          port                = 80
          protocol            = "HTTP"
          timeout             = 2
          unhealthy_threshold = 2
        }
      }
    ]
    tags = {
      Environment = "dev"
      App         = "lb"
      Resource    = "Managed by Terraform"
      Description = "LB Related Configuration"
      Team        = "Devops"
    }
  }
}

variable "default_actions" {
  type = object({
    fixed_response = optional(object({
      create = bool
      type   = string
      #(Required) Content type. Valid values are 'text/plain', 'text/css', 'text/html', 'application/javascript' and 'application/json'.
      content_type = string
      # (Optional) Message body.
      message_body = optional(string)
      # (Optional) HTTP response code. Valid values are 2XX, 4XX, or 5XX
      status_code = optional(string)
    }))
    redirect = optional(object({
      create      = bool
      type        = string
      protocol    = string
      port        = optional(string)
      status_code = optional(string)
    }))

  })
  default = {
    redirect = {
      create      = false
      port        = 443
      type        = "redirect"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    fixed_response = {
      create       = false
      type         = "fixed_response"
      status_code  = "200"
      content_type = "text/plain"
      message_body = "Fixed response content"
    }

  }
}
