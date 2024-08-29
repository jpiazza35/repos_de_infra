module "alb" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//alb?ref=1.0.153"

  alb = {
    app                              = var.app
    env                              = var.env
    team                             = "Devops"
    load_balancer_type               = "application"
    internal                         = true
    create_security_group            = true
    create_static_public_ip          = false
    enable_cross_zone_load_balancing = false
    vpc_id                           = data.aws_vpc.vpc.id
    access_logs = {
      enabled = true
      prefix  = ""
      bucket  = ""
    }
    security_group = {
      description = "${var.app} ALB security group"
      ids         = []
      ingress = [
        {
          description = "HTTPS access to ALB"
          from_port   = 443
          to_port     = 443
          protocol    = "TCP"
          cidr_blocks = ["10.0.0.0/8"]
        }
      ]
      egress = []
    }
    enable_deletion_protection = true
    listeners = [
      {
        port             = "443"
        protocol         = "HTTPS"
        acm_arn          = module.acm.arn
        action_type      = "forward"
        target_group_arn = ""
      },

    ]
    target_groups = [
      {
        name_prefix                        = var.app
        vpc_id                             = data.aws_vpc.vpc.id
        protocol                           = "HTTPS"
        port                               = 443
        deregistration_delay               = 300
        target_type                        = "ip"
        load_balancing_cross_zone_enabled  = "false"
        lambda_multi_value_headers_enabled = false
        protocol_version                   = "HTTP1"
        enable_lb_target_group_attachment  = true
        targets                            = local.targets ## We are using VPC endpoint IPs as targets here.
        health_check = {
          enabled           = true
          healthy_threshold = 5
          interval          = 30
          ## Matcher is required for VPCE IP targets. See: https://aws.amazon.com/blogs/networking-and-content-delivery/hosting-internal-https-static-websites-with-alb-s3-and-privatelink/
          matcher             = "200,307,405"
          path                = "/index.html"
          port                = 443
          protocol            = "HTTP"
          timeout             = 5
          unhealthy_threshold = 2
        }
      },

    ]
    tags = {
      Environment = var.env
      App         = var.app
      Resource    = "Managed by Terraform"
      Description = "ALB for ${var.app} in ${var.env} environment"
      Team        = "Devops"
    }
  }
}

module "dns" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//dns?ref=1.0.153"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env               = var.env
  vpc_id            = data.aws_vpc.vpc.id
  lb_dns_name       = module.alb.lb_dns_name
  lb_dns_zone       = module.alb.lb_dns_zone
  dns_name          = var.dns_name
  record_prefix     = var.env == "prod" ? [var.app] : ["${var.app}.${var.env}"]
  create_local_zone = false
  tags = {
    Environment = var.env
    App         = var.app
    Resource    = "Managed by Terraform"
    Description = "Data Quality DNS Related Configuration"
    Team        = "Devops"
  }
}
