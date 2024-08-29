# Create public route tables
resource "aws_route_table" "public" {

  for_each = {
    for s in aws_subnet.public : s.availability_zone_id => s
  }
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = format(
        "%s-%s-public",
        aws_vpc.vpc.tags["Name"],
        substr(
          each.key, -3, -1
        )
      ),
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
  lifecycle {
    ignore_changes = [
      route
    ]
  }
}

# Create route entry for internet gateway.
resource "aws_route" "pub_igw" {
  for_each               = { for s in aws_subnet.public : s.availability_zone_id => s }
  route_table_id         = aws_route_table.public[each.key].id
  depends_on             = [aws_route_table.public]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary[0].id
}

# Create private route tables
resource "aws_route_table" "private" {

  for_each = { for s in aws_subnet.private : s.availability_zone_id => s }
  vpc_id   = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s-private", aws_vpc.vpc.tags["Name"], substr(each.key, -3, -1))
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
  lifecycle {
    ignore_changes = [
      route
    ]
  }
}

# Associate route tables to respective subnets
resource "aws_route_table_association" "public" {
  for_each = { for s in aws_subnet.public : s.availability_zone_id => s }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = { for s in aws_subnet.private : s.availability_zone_id => s }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

# Tag default route table
resource "aws_ec2_tag" "default_rtb" {
  resource_id = aws_vpc.vpc.default_route_table_id
  for_each = merge(
    var.tags,
    {
      Name = format(
        "%s-local",
        aws_vpc.vpc.tags["Name"]
      ),
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
  key   = each.key
  value = each.value
}
