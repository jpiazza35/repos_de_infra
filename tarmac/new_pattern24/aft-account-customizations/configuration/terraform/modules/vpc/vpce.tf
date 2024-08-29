resource "aws_vpc_endpoint" "vpce" {
  for_each          = var.vpc_parameters["endpoints"]
  vpc_id            = aws_vpc.vpc.id
  service_name      = data.aws_vpc_endpoint_service.svc[each.key].service_name
  vpc_endpoint_type = lookup(each.value, "service_type", "Interface")
  auto_accept       = lookup(each.value, "auto_accept", null)

  security_group_ids  = lookup(each.value, "service_type", "Interface") == "Interface" ? aws_security_group.private.*.id : null
  subnet_ids          = lookup(each.value, "service_type", "Interface") == "Interface" ? aws_subnet.private.*.id : null
  route_table_ids     = lookup(each.value, "service_type", "Interface") == "Gateway" ? distinct(local.private_route_tables) : null
  policy              = lookup(each.value, "policy", null)
  private_dns_enabled = lookup(each.value, "service_type", "Interface") == "Interface" ? lookup(each.value, "private_dns_enabled", null) : null

  tags = merge(
    var.tags,
    {
      Name           = format("%s", each.key)
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    },
  )
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id              = aws_vpc.vpc.id
  service_name        = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = aws_security_group.private.*.id
  subnet_ids          = aws_subnet.private.*.id
  private_dns_enabled = true
  tags = merge(
    var.tags,
    {
      Name           = format("s3-interface")
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    },
  )
}
