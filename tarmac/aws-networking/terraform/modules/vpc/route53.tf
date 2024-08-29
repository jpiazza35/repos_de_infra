# Associate shared route53 resolver rules to the VPC that are shared from the TGW account
resource "aws_route53_resolver_rule_association" "forwarders" {
  for_each = {
    for r in data.aws_route53_resolver_rule.forwarders : r.id => r
    if r.owner_id == data.aws_ec2_transit_gateway.tgw.owner_id
  }
  resolver_rule_id = each.key
  vpc_id           = aws_vpc.vpc.id
  name             = aws_vpc.vpc.tags_all.Name

  lifecycle {
    ignore_changes = [
      name
    ]
  }
}
