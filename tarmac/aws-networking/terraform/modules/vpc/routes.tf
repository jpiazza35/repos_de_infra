# Create public route tables
resource "aws_route_table" "public" {

  for_each = {
    for s in aws_subnet.public : s.availability_zone_id => s
  }
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s-public", aws_vpc.vpc.tags["Name"], substr(each.key, -3, -1))
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
  lifecycle {
    ignore_changes = [
      route
    ]
  }
}

# Create route entry for org supernet if TGW is attached.
resource "aws_route" "pub_supernet" {
  for_each = var.attach_to_tgw ? {
    for s in aws_subnet.public : s.availability_zone_id => s
  } : {}
  route_table_id         = aws_route_table.public[each.key].id
  depends_on             = [aws_route_table.public, aws_ec2_transit_gateway_vpc_attachment.tgwa]
  destination_cidr_block = local.org_supernet_cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}

# Create route entry for internet gateway.
resource "aws_route" "pub_igw" {
  for_each = {
    for s in aws_subnet.public : s.availability_zone_id => s
  }
  route_table_id         = aws_route_table.public[each.key].id
  depends_on             = [aws_route_table.public]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary[0].id
}

# Create private route tables
resource "aws_route_table" "private" {

  for_each = {
    for s in aws_subnet.private : s.availability_zone_id => s
  }
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s-private", aws_vpc.vpc.tags["Name"], substr(each.key, -3, -1))
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
  lifecycle {
    ignore_changes = [
      route
    ]
  }
}

# If NAT Gateways exist, create route entries for the private route tables to use them.
resource "aws_route" "prv_with_ngw" {
  for_each = length(aws_nat_gateway.main) != 0 ? {
    for s in aws_subnet.private : s.availability_zone_id => s
  } : {}
  route_table_id         = aws_route_table.private[each.key].id
  depends_on             = [aws_route_table.private]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[each.key].id
}

# If no NAT Gateways exist, create route entries for the private route tables to use the TGW if attached.
resource "aws_route" "prv_without_ngw" {
  for_each = length(aws_nat_gateway.main) == 0 && var.attach_to_tgw ? {
    for s in aws_subnet.private : s.availability_zone_id => s
  } : {}
  route_table_id         = aws_route_table.private[each.key].id
  depends_on             = [aws_route_table.private, aws_ec2_transit_gateway_vpc_attachment.tgwa]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}

# Create route entry for org supernet if TGW is attached.
resource "aws_route" "prv_supernet" {
  for_each = var.attach_to_tgw ? {
    for s in aws_subnet.private : s.availability_zone_id => s
  } : {}
  route_table_id = aws_route_table.private[each.key].id
  depends_on = [
    aws_route_table.private,
    aws_ec2_transit_gateway_vpc_attachment.tgwa
  ]
  destination_cidr_block = local.org_supernet_cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
}

# Associate route tables to respective subnets
resource "aws_route_table_association" "public" {
  for_each = {
    for s in aws_subnet.public : s.availability_zone_id => s
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = {
    for s in aws_subnet.private : s.availability_zone_id => s
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "transit" {
  for_each = var.enable_nat_gateways ? {
    for s in aws_subnet.transit : s.availability_zone_id => s
  } : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
