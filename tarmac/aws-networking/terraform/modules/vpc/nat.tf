# Create NAT Gateways
resource "aws_nat_gateway" "main" {
  for_each = var.enable_public_subnets && var.enable_nat_gateways ? {
    for s in aws_subnet.public : s.availability_zone_id => s
  } : {}

  subnet_id     = each.value.id
  allocation_id = aws_eip.nat[each.key].id

  tags = merge(
    var.tags,

    {
      Name = format("%s-%s-ngw", aws_vpc.vpc.tags["Name"], substr(each.key, -3, -1))
    }
  )
}
