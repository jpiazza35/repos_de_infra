resource "aws_route53_record" "certs" {
  provider = aws.ss_network
  for_each = {
    for dvo in var.cert.domain_validation_options : dvo.resource_record_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records = [
    each.value.record
  ]
  ttl     = 300
  type    = each.value.type
  zone_id = var.dns_zone_id == "" ? data.aws_route53_zone.selected.zone_id : var.dns_zone_id
}