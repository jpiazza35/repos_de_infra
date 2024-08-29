### ALB Module
Call this module using the example below:

```bash
module "alb" {
  source  = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//alb"
  alb = {
    app                   = "alb"
    env                   = "dev"
    team                  = "devops"
    load_balancer_type    = "application" # application | network
    internal              = true 
    subnets               = [] # optional
    create_security_group = true
    security_group = {
      ids = [] # optional
      description = "" # optional
      ingress = [
        {
          description = "test"
          from_port   = 80
          to_port     = 80
          protocol    = "TCP"
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
    enable_deletion_protection = false
    access_logs = {
      bucket  = "" # optional
      prefix  = "" # optional
      enabled = true
    }
    vpc_id = "" # optional
    listeners = [
      {
        port             = "80"
        protocol         = "HTTP"
        acm_arn          = "" # optional
        target_group_arn = "" # optional
        action_type      = "redirect" # redirect | fixed_response
      },
      {
        port             = "80"
        protocol         = "HTTP"
        acm_arn          = "" # optional
        target_group_arn = "" # optional
        action_type      = "fixed_response" # redirect | fixed_response
      },
    ]
    target_groups = [
      {
        name_prefix                        = "tg"
        vpc_id                             = "" # optional
        protocol                           = "HTTP"
        port                               = 80
        deregistration_delay               = 300
        target_type                        = "ip" # ip | instance | lambda | alb
        load_balancing_cross_zone_enabled  = "use_load_balancer_configuration" # "true" | "false" | "use_load_balancer_configuration"
        lambda_multi_value_headers_enabled = false
        protocol_version                   = "HTTP1" #HTTP1 | HTTP2 | GRPC
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
      App         = "alb"
      Resource    = "Managed by Terraform"
      Description = "ALB Related Configuration"
      Team        = "Devops"
    }
  }
}
```
