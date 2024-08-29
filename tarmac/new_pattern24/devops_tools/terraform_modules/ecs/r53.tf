resource "aws_route53_record" "private" {
  count   = var.create_r53_record ? 1 : 0
  zone_id = var.internal_dns_id
  name    = var.tags["Application"]
  type    = "CNAME"
  ttl     = "60"

  records = ["${var.tags["Environment"]}.${var.tags["Application"]}"]
}
