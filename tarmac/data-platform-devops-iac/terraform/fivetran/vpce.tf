resource "aws_vpc_endpoint_service" "fivetran" {
  acceptance_required = true
  network_load_balancer_arns = [
    module.nlb.alb_arn
  ]
  allowed_principals = [
    "arn:aws:iam::${var.fivetran_aws_account_id}:root"
  ]
  private_dns_name = format("%s.%s", local.prefix, var.dns_name)

  supported_ip_address_types = [
    "ipv4"
  ]
  tags = merge(
    var.tags,
    {
      Name        = format("%s-vpce-service", local.prefix)
      Environment = var.env
      Component   = "${title(var.app)} Infrastructure"
    }
  )
}
module "nlb" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//alb?ref=1.0.50"
  alb = {
    app                     = var.app
    env                     = var.env
    team                    = "devops"
    load_balancer_type      = "network"
    internal                = true
    create_security_group   = true
    create_static_public_ip = false
    vpc_id                  = ""
    access_logs = {
      bucket  = ""
      prefix  = var.app
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
          description = "databricks"
          from_port   = 443
          to_port     = 443
          protocol    = "TCP"
          cidr_blocks = [
            "10.0.0.0/32",    #nonprod
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
        protocol         = "TCP"
        action_type      = "default"
        target_group_arn = ""
        # acm_arn          = module.acm.acm
      },
    ]
    target_groups = [
      {
        vpc_id                             = ""
        name_prefix                        = "${var.app}"
        protocol                           = "TCP"
        port                               = 443
        deregistration_delay               = 300
        target_type                        = "alb"
        load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
        lambda_multi_value_headers_enabled = false
        protocol_version                   = "HTTP1"
        health_check = {
          enabled             = true
          healthy_threshold   = 2
          interval            = 5
          matcher             = ""
          path                = ""
          port                = 443
          protocol            = "HTTPS"
          timeout             = 2
          unhealthy_threshold = 2
        }
      }
    ]
    tags = {
      Environment    = var.env
      App            = var.app
      Resource       = "Managed by Terraform"
      Description    = "NLB Related Configuration"
      Team           = "Devops"
      SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    }
  }
}

resource "aws_lb_target_group_attachment" "nlb_to_alb" {
  target_group_arn = module.nlb.target_group_arn

  target_id = module.alb.alb_arn
  port      = 443

  depends_on = [module.alb]
}


module "acm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm?ref=1.0.50"
  providers = {
    aws = aws
  }
  env         = var.env
  dns_zone_id = ""
  dns_name    = var.dns_name
  san = [
    var.app
  ]
  create_wildcard = false
  tags = merge(
    var.tags,
    {
      Environment = var.env
      App         = var.app
      Resource    = "Managed by Terraform"
      Description = "DNS Related Configuration"
      Team        = "DevOps"
    }
  )
}

module "acm_validation" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm_validation?ref=1.0.50"
  providers = {
    aws.ss_network = aws.ss_network
  }
  depends_on = [
    module.acm
  ]
  env         = var.env
  dns_name    = var.dns_name
  dns_zone_id = ""
  cert        = module.acm.cert
}

resource "aws_acm_certificate_validation" "validate" {
  certificate_arn         = module.acm.acm
  validation_record_fqdns = module.acm_validation.fqdns
}

resource "aws_route53_record" "vpce_service_txt" {
  provider = aws.ss_network
  zone_id  = data.aws_route53_zone.selected.zone_id

  name = aws_vpc_endpoint_service.fivetran.private_dns_name_configuration[0].name

  type = aws_vpc_endpoint_service.fivetran.private_dns_name_configuration[0].type

  records = aws_vpc_endpoint_service.fivetran.private_dns_name_configuration[*].value

  ttl = 300
}
