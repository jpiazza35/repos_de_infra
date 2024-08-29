resource "aws_route53_record" "cf" {
  provider = aws.ss_network
  for_each = {
    for r in local.flat_r53_record : r.name => r
  }
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value.alias
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf[each.key].domain_name
    zone_id                = aws_cloudfront_distribution.cf[each.key].hosted_zone_id
    evaluate_target_health = true
  }

}