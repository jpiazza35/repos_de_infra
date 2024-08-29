resource "aws_acm_certificate" "payment_ch" {
  count             = var.create_dns_certs ? 1 : 0
  domain_name       = "*.${aws_route53_zone.public[count.index].name}"
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = aws_route53_zone.public[count.index].name
    },
    var.tags
  )

  depends_on = [
    aws_route53_record.env_zones_ns_records
  ]
}

resource "aws_route53_record" "cert_payment_ch" {

  for_each = {
    for dvo in flatten([for cert in aws_acm_certificate.payment_ch : cert.domain_validation_options]) : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.public[0].id
}

resource "aws_acm_certificate_validation" "cert_payment_ch" {
  count                   = var.create_dns_certs ? 1 : 0
  certificate_arn         = aws_acm_certificate.payment_ch[count.index].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_payment_ch : record.fqdn]
}

resource "aws_acm_certificate" "env_subdomains_certs" {
  count             = var.create_dns_certs ? length(var.environments) : 0
  domain_name       = "*.${aws_route53_zone.env_public[count.index].name}"
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = aws_route53_zone.env_public[count.index].name
    },
    var.tags
  )

  depends_on = [
    aws_route53_record.env_zones_ns_records
  ]
}

resource "aws_route53_record" "env_subdomains_certs" {
  count = var.create_dns_certs ? length(var.environments) : 0

  allow_overwrite = true
  name            = tolist(aws_acm_certificate.env_subdomains_certs[count.index].domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.env_subdomains_certs[count.index].domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.env_subdomains_certs[count.index].domain_validation_options)[0].resource_record_type
  ttl             = 60
  zone_id         = aws_route53_zone.env_public[count.index].id
}

resource "aws_acm_certificate_validation" "env_subdomains_certs" {
  count                   = var.create_dns_certs ? length(var.environments) : 0
  certificate_arn         = aws_acm_certificate.env_subdomains_certs[count.index].arn
  validation_record_fqdns = [aws_route53_record.env_subdomains_certs[count.index].fqdn]
}

resource "aws_acm_certificate" "apps_subdomains_certs" {
  count             = var.create_apps_dns_resources ? 1 : 0
  domain_name       = "*.${aws_route53_zone.apps_public[count.index].name}"
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = aws_route53_zone.apps_public[count.index].name
    },
    var.tags
  )

  # depends_on = [
  #   aws_route53_record.apps_zones_ns_records
  # ]
}

resource "aws_route53_record" "apps_subdomains_certs" {

  for_each = {
    for dvo in flatten([for cert in aws_acm_certificate.apps_subdomains_certs : cert.domain_validation_options]) : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.apps_public[0].id
}

resource "aws_acm_certificate_validation" "apps_subdomains_certs" {
  count                   = var.create_apps_dns_resources ? 1 : 0
  certificate_arn         = aws_acm_certificate.apps_subdomains_certs[count.index].arn
  validation_record_fqdns = [for record in aws_route53_record.apps_subdomains_certs : record.fqdn]
}

resource "aws_acm_certificate" "ds_subdomain_cert" {
  count             = var.create_ds_dns_resources ? 1 : 0
  domain_name       = "*.${aws_route53_zone.ds_public[count.index].name}"
  validation_method = "DNS"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = aws_route53_zone.ds_public[count.index].name
    },
    var.tags
  )

  # depends_on = [
  #   aws_route53_record.ds_zone_ns_records
  # ]
}

resource "aws_route53_record" "ds_subdomain_cert" {

  for_each = {
    for dvo in flatten([for cert in aws_acm_certificate.ds_subdomain_cert : cert.domain_validation_options]) : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.ds_public[0].id
}

resource "aws_acm_certificate_validation" "ds_subdomain_cert" {
  count                   = var.create_ds_dns_resources ? 1 : 0
  certificate_arn         = aws_acm_certificate.ds_subdomain_cert[count.index].arn
  validation_record_fqdns = [for record in aws_route53_record.ds_subdomain_cert : record.fqdn]
}
