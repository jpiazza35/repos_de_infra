resource "aws_route53_zone" "local_zone" {
  provider = aws

  count = var.create_local_zone && terraform.workspace != "default" ? 1 : 0

  name = var.hosted_zone_name != "" ? format("%s.%s", var.hosted_zone_name, var.dns_name) : var.dns_name

  comment = var.comment

  dynamic "vpc" {
    for_each = var.vpc_id != "" ? toset([var.vpc_id]) : toset([])
    content {
      vpc_id = vpc.value
    }

  }

  lifecycle {
    ignore_changes = [
      vpc
    ]
  }

}

resource "aws_route53_record" "app_alb" {
  provider = aws.ss_network
  for_each = var.record_prefix != "" && terraform.workspace != "default" ? toset(var.record_prefix) : toset([])
  zone_id  = data.aws_route53_zone.selected[0].zone_id
  name     = format("%s.%s", each.value, var.dns_name)
  type     = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_dns_zone
    evaluate_target_health = true
  }

}

resource "aws_route53_health_check" "health_alb" {
  provider = aws
  for_each = var.record_prefix != "" && terraform.workspace != "default" ? toset(var.record_prefix) : toset([])

  fqdn              = var.lb_dns_name
  type              = "TCP"
  port              = "443"
  failure_threshold = "5"
  request_interval  = "30"
}
