# Create the TGW Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgwa" {
  count = var.attach_to_tgw ? 1 : 0

  transit_gateway_id = data.aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc.id
  subnet_ids         = aws_subnet.transit[*].id

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  tags = merge(
    var.tags,
    {
      Name           = format("%s-tgw", aws_vpc.vpc.tags["Name"])
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}

# Create route entry for org supernet if TGW is attached.
resource "aws_route" "pub_supernet" {
  for_each = var.attach_to_tgw ? {
    for s in aws_subnet.public : s.availability_zone_id => s
  } : {}
  route_table_id = aws_route_table.public[each.key].id
  depends_on = [
    aws_route_table.public,
    aws_ec2_transit_gateway_vpc_attachment.tgwa
  ]
  destination_cidr_block = var.vpc_parameters["networking"]["org_cidr_block"]
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}

# Create route entries for the private route tables to use the TGW if attached.
resource "aws_route" "private" {
  for_each = var.attach_to_tgw ? {
    for s in aws_subnet.private : s.availability_zone_id => s
  } : {}
  route_table_id = aws_route_table.private[each.key].id
  depends_on = [
    aws_route_table.private,
    aws_ec2_transit_gateway_vpc_attachment.tgwa
  ]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}

# Associate shared route53 resolver rules to the VPC that are shared from the TGW account
resource "aws_route53_resolver_rule_association" "forwarders" {
  for_each = {
    for r in data.aws_route53_resolver_rule.forwarders : r.id => r
    if r.owner_id == data.aws_ec2_transit_gateway.tgw.owner_id
  }
  resolver_rule_id = each.key
  vpc_id           = aws_vpc.vpc.id
}
