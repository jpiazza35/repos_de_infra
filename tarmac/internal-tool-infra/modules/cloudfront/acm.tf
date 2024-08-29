resource "aws_acm_certificate" "staplerroja" {
  domain_name       = "*.staplerroja.com"
  validation_method = "DNS"

  tags = {
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "staplerroja" {
  count                   = var.environment == "dev" ? 1 : 0
  certificate_arn         = aws_acm_certificate.staplerroja.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_cf_r53 : record.fqdn]
}
