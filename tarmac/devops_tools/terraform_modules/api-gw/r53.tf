resource "aws_route53_record" "api_gw" {
  count = length(var.client_subdomains)

  name    = "${var.client_subdomains[count.index]}.${var.tags["Application"]}.${var.env_public_dns_name}"
  type    = "A"
  zone_id = var.app_public_dns_id

  alias {
    evaluate_target_health = true
    name                   = var.mtls ? aws_api_gateway_domain_name.mtls[0].regional_domain_name : aws_api_gateway_domain_name.no_mtls[0].regional_domain_name
    zone_id                = var.mtls ? aws_api_gateway_domain_name.mtls[0].regional_zone_id : aws_api_gateway_domain_name.no_mtls[0].regional_zone_id
  }
}

# These are the A records from the ds.{env}.example-account-cloud-payment.ch zones set in the corresponding {env}.example-account-cloud-payment.ch DNS
resource "aws_route53_record" "ds_zone_records" {
  count = var.create_ds_dns_resources ? length(var.ds_cards_records) : 0

  name    = var.create_ds_dns_resources ? var.ds_cards_records[count.index] : 0
  type    = "A"
  zone_id = var.create_ds_dns_resources ? var.ds_public_dns_id : 0

  alias {
    evaluate_target_health = true
    name                   = var.create_ds_dns_resources ? aws_api_gateway_domain_name.ds[count.index].regional_domain_name : 0
    zone_id                = var.create_ds_dns_resources ? aws_api_gateway_domain_name.ds[count.index].regional_zone_id : 0
  }
}
