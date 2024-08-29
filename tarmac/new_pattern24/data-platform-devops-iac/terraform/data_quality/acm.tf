module "acm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm?ref=1.0.153"
  providers = {
    aws = aws
  }
  env             = var.env
  dns_zone_id     = ""
  dns_name        = var.dns_name
  san             = var.env == "prod" ? [var.app] : ["${var.app}.${var.env}"]
  create_wildcard = false ## Should a wildcard certificate be created, if omitted, you must specify value(s) for the `san` variable
  tags = merge(
    var.tags,
    {
      Environment = var.env
      App         = var.app
      Resource    = "Managed by Terraform"
      Description = "Data Quality ACM Related Configuration"
      Team        = "DevOps"
    }
  )
}

resource "aws_route53_record" "acm_validation" {
  provider = aws.ss_network
  for_each = {
    for dvo in module.acm.acm_dvo : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
}

resource "aws_acm_certificate_validation" "acm" {
  certificate_arn         = module.acm.acm
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}

