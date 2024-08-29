# Static API request certificate
resource "aws_acm_certificate" "certificate_request" {
  domain_name       = "*.${var.public_dns_zone_name}"
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = var.public_dns_zone_name
    },
    var.tags
  )

  #depends_on = [
  #  aws_route53_record.api_route53_record
  #]
}


resource "aws_route53_record" "certificate_request" {

  for_each = {
    #for dvo in flatten([for cert in aws_acm_certificate.api_certificate_request : cert.domain_validation_options]) : dvo.domain_name => {
    for dvo in aws_acm_certificate.certificate_request.domain_validation_options : dvo.domain_name => {
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
  zone_id         = var.public_dns_zone_id
}

#check validation record fqdns
resource "aws_acm_certificate_validation" "certificate_request_validation" {
  certificate_arn         = aws_acm_certificate.certificate_request.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_request : record.fqdn]
}

resource "aws_route53_record" "api_route53_record" {
  zone_id = var.public_dns_zone_id
  name    = "api.${var.public_dns_zone_name}"
  type    = "A"

  alias {
    name                   = var.lb_dns
    zone_id                = var.lb_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "frontend_route53_record" {
  name            = "app.${var.public_dns_zone_name}"
  records         = [var.cloudfront_domain_name]
  type            = "CNAME"
  allow_overwrite = true
  ttl             = 60
  zone_id         = var.public_dns_zone_id
}
