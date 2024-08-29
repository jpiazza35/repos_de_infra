module "alb" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//alb?ref=1.0.50"
  alb = {
    app                     = "${var.app}-alb"
    env                     = var.env
    team                    = "devops"
    load_balancer_type      = "application"
    internal                = true
    create_security_group   = true
    create_static_public_ip = false
    vpc_id                  = ""
    access_logs = {
      bucket  = ""
      prefix  = "${var.app}-alb"
      enabled = true
    }
    security_group = {
      ids = []
      ingress = [
        {
          description = "mssql"
          from_port   = 1433
          to_port     = 1433
          protocol    = "TCP"
          cidr_blocks = [
            "10.0.0.0/32",
            "3.239.194.48/29" # Fivetran IPs (US): https://fivetran.com/docs/using-fivetran/ips#aws
          ]
        },
        {
          description = "psql"
          from_port   = 5432
          to_port     = 5432
          protocol    = "TCP"
          cidr_blocks = [
            "10.0.0.0/32",
            "3.239.194.48/29" # Fivetran IPs (US): https://fivetran.com/docs/using-fivetran/ips#aws
          ]
        },
        {
          description = "https"
          from_port   = 443
          to_port     = 443
          protocol    = "TCP"
          cidr_blocks = [
            "10.0.0.0/32",    # nonprod
            "10.0.0.0/31",    # prod
            "3.239.194.48/29" # Fivetran IPs (US): https://fivetran.com/docs/using-fivetran/ips#aws
          ]
        },
      ]
      egress = []
    }
    enable_deletion_protection = false
    listeners = [
      {
        port             = "443"
        protocol         = "HTTPS"
        action_type      = "default"
        target_group_arn = ""
        acm_arn          = module.acm.acm
      },
    ]
    target_groups = [
      {
        vpc_id                             = ""
        name_prefix                        = "${var.app}-alb"
        protocol                           = "HTTP"
        port                               = 1433
        deregistration_delay               = 300
        target_type                        = "ip"
        load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
        lambda_multi_value_headers_enabled = false
        protocol_version                   = "HTTP1"
        health_check = {
          enabled             = true
          healthy_threshold   = 2
          interval            = 5
          matcher             = ""
          path                = ""
          port                = 1433
          protocol            = "HTTP"
          timeout             = 2
          unhealthy_threshold = 2
        }
      }
    ]
    tags = {
      Environment    = var.env
      App            = "${var.app}-alb"
      Resource       = "Managed by Terraform"
      Description    = "NLB Related Configuration"
      Team           = "Devops"
      SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    }
  }
}

