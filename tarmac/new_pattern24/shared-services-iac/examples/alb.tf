module "alb" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//alb?ref=v1.0.0"
  alb = {
    app                   = "alb"
    env                   = "dev"
    team                  = "devops"
    load_balancer_type    = "application" # application | network
    internal              = true
    create_security_group = true
    vpc_id                = ""
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
        enable_lb_target_group_attachment  = true
        vpc_id                             = ""
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
