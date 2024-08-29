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
  name    = "fe-dev"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.internal_tool_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.internal_tool_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cf_r53_prod" {
  provider = aws.dev_account
  count    = var.environment == "prod" ? 1 : 0
  zone_id  = data.aws_route53_zone.staplerroja_prod[count.index].zone_id
  name     = "internal-tool"
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.internal_tool_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.internal_tool_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert_cf_r53" {

  for_each = var.environment == "dev" ? {
    for dvo in aws_acm_certificate.staplerroja.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.staplerroja[0].id
}