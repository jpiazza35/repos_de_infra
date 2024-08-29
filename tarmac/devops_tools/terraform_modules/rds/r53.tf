resource "aws_route53_record" "private" {
  count   = var.create_r53_record ? 1 : 0
  zone_id = var.internal_dns_id
  name    = var.rds_internal_dns
  type    = "CNAME"
  ttl     = "300"

  records = [aws_db_instance.postgresql.address]
}
