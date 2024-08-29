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
