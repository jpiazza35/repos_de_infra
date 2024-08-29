/* resource "aws_vpc_endpoint_service" "databricks" {
  acceptance_required = true
  network_load_balancer_arns = [
    aws_lb.nexla_to_databricks.arn
  ]
  allowed_principals = [
    var.nexla_aws_account_id
  ]
  private_dns_name = format("cn-%s-nexla.%s", local.prefix, var.dns_name)

  supported_ip_address_types = [
    "ipv4"
  ]
  tags = merge(
    var.tags,
    {
      Name        = format("%s-nexla-vpce-service", local.prefix)
      Environment = var.env
      Component   = "Databricks Infrastructure"
    }
  )
}

resource "aws_s3_bucket" "nexla_vpce_access_logs" {
  bucket = format("%s-nexla-nlb-access-logs", local.prefix)

  tags = merge(
    var.tags,
    {
      Name        = format("%s-nexla-nlb-access-logs", local.prefix)
      Environment = var.env
      Component   = "Databricks Infrastructure"
    }
  )
}

resource "aws_lb" "nexla_to_databricks" {
  name               = format("%s-nexla-nlb", local.prefix)
  load_balancer_type = "network"
  internal           = true

  dynamic "subnet_mapping" {
    for_each = [
      for i in var.private_subnet_ids : i
    ]
    content {
      subnet_id = subnet_mapping.value[0]
    }

  }

  access_logs {
    bucket  = aws_s3_bucket.nexla_vpce_access_logs.id
    enabled = true
  }

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true

  tags = merge(
    var.tags,
    {
      Name        = format("%s-nexla-nlb", local.prefix)
      Environment = var.env
      Component   = "Databricks Infrastructure"
    }
  )
}

resource "aws_lb_listener" "nexla_databricks_nlb" {
  load_balancer_arn = aws_lb.nexla_to_databricks.arn
  port              = "443"
  protocol          = "TLS"
  certificate_arn   = module.acm.acm
  alpn_policy       = "HTTP2Preferred"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nexla_databricks_nlb.arn
  }

  tags = merge(
    var.tags,
    {
      Name        = format("%s-nexla-nlb", local.prefix)
      Environment = var.env
      Component   = "Databricks Infrastructure"
    }
  )
}

resource "aws_lb_target_group" "nexla_databricks_nlb" {
  name        = format("%s-nexla-nlb-tg", local.prefix)
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group_attachment" "nexla_databricks_nlb" {
  for_each         = data.aws_network_interface.databricks_vpce
  target_group_arn = aws_lb_target_group.nexla_databricks_nlb.arn
  target_id        = each.value.private_ip
  port             = 443
}

resource "aws_route53_record" "vpce_service_txt" {
  provider = aws.ss_network
  zone_id  = data.aws_route53_zone.selected.zone_id

  name = aws_vpc_endpoint_service.databricks.private_dns_name_configuration[0].name

  type = aws_vpc_endpoint_service.databricks.private_dns_name_configuration[0].type

  records = [
    aws_vpc_endpoint_service.databricks.private_dns_name_configuration[0].value
  ]
}

resource "aws_route53_record" "databricks_workspace_alias" {
  provider = aws.ss_network
  zone_id  = data.aws_route53_zone.selected.zone_id

  name = format("cn-%s", local.prefix)

  type = "A"

  alias {
    name                   = format("cn-%s.%s", local.prefix, var.dns_name)
    zone_id                = data.aws_route53_zone.selected.zone_id
    evaluate_target_health = true
  }
}

module "acm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  dns_name        = var.dns_name
  san             = aws_vpc_endpoint_service.databricks.private_dns_name_configuration[0].name
  create_wildcard = false
  dns_zone_id     = data.aws_route53_zone.selected.zone_id
  tags = merge(
    var.tags,
    {
      Environment = var.env
      App         = var.app
      Resource    = "Managed by Terraform"
      Description = "Certificate Management Configuration"
      Team        = "Data Platform"
    }
  )
}

module "dns" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//dns"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env = var.env
  record_prefix = [
    format("cn-%s-nexla", local.prefix),
    format("cn-%s.cn-%s", local.prefix)
  ]
  vpc_id      = var.vpc_id
  lb_dns_name = aws_lb.nexla_to_databricks.dns_name
  lb_dns_zone = aws_lb.nexla_to_databricks.zone_id
  dns_name    = var.dns_name
  tags = merge(
    var.tags,
    {
      Environment = var.env
      App         = var.app
      Resource    = "Managed by Terraform"
      Description = "DNS Related Configuration"
      Team        = "Data Platform"
    }
  )
} */
