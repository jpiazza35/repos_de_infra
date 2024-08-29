# These are the NS records from the {env}.example-account-cloud-payment.ch zones set in the main example-account-cloud-payment.ch DNS in Shared Services account
resource "aws_route53_record" "env_zones_ns_records" {
  count   = var.create_env_dns_resources ? length(var.environments) : 0
  name    = var.environments[count.index]
  ttl     = 172800
  type    = "NS"
  zone_id = aws_route53_zone.public[0].zone_id

  records = aws_route53_zone.env_public[count.index].name_servers
}

# These are the NS records from the {app}.{env}.example-account-cloud-payment.ch zones set in the corresponding {env}.example-account-cloud-payment.ch DNS
resource "aws_route53_record" "apps_zones_ns_records" {
  provider = aws.shared-services

  count   = var.create_apps_dns_resources ? 1 : 0
  name    = var.tags["Application"]
  ttl     = 172800
  type    = "NS"
  zone_id = var.env_public_dns_id

  records = aws_route53_zone.apps_public[count.index].name_servers
}

# These are the NS records from the ds.{env}.example-account-cloud-payment.ch zones set in the corresponding {env}.example-account-cloud-payment.ch DNS
resource "aws_route53_record" "ds_zone_ns_records" {
  provider = aws.shared-services

  count   = var.create_ds_dns_resources ? 1 : 0
  name    = var.ds_dns_name
  ttl     = 172800
  type    = "NS"
  zone_id = var.env_public_dns_id

  records = aws_route53_zone.ds_public[count.index].name_servers
}
