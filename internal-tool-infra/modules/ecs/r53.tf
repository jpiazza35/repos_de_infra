/*
resource "aws_route53_record" "services_internal_records" {
  for_each = { for key, val in var.config_services : key => val if val.type != "worker" }
  zone_id  = var.internal_dns_id
  name     = each.value.service
  type     = "A"

  alias {
    name                   = aws_lb.internal.dns_name
    zone_id                = aws_lb.internal.zone_id
    evaluate_target_health = false
  }
}
*/

data "aws_route53_zone" "staplerroja" {
  count        = var.environment == "dev" ? 1 : 0
  name         = "staplerroja.com"
  private_zone = false
}

data "aws_route53_zone" "staplerroja_prod" {
  provider     = aws.dev_account
  count        = var.environment == "prod" ? 1 : 0
  name         = "staplerroja.com"
  private_zone = false
}

resource "aws_route53_record" "cf_r53" {
  count   = var.environment == "dev" ? 1 : 0
  zone_id = data.aws_route53_zone.staplerroja[count.index].zone_id
  name    = "dev"
  type    = "A"

  alias {
    name                   = "dualstack.${aws_lb.external.dns_name}"
    zone_id                = aws_lb.external.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cf_r53_prod" {
  provider = aws.dev_account
  count    = var.environment == "prod" ? 1 : 0
  zone_id  = data.aws_route53_zone.staplerroja_prod[count.index].zone_id
  name     = "prod"
  type     = "A"

  alias {
    name                   = "dualstack.${aws_lb.external.dns_name}"
    zone_id                = aws_lb.external.zone_id
    evaluate_target_health = true
  }
}