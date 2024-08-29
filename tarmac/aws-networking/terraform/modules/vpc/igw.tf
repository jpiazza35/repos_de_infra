# Create internet gateway for new VPC
resource "aws_internet_gateway" "primary" {
  count = var.enable_public_subnets ? 1 : 0

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format("%s-igw", aws_vpc.vpc.tags["Name"])
  }
}

# Create elastic IPs for each NAT Gateway
resource "aws_eip" "nat" {
  for_each = var.enable_nat_gateways ? {
    for s in aws_subnet.public : s.availability_zone_id => s
  } : {}
  depends_on = [aws_internet_gateway.primary]
  domain     = "vpc"
  tags = merge(
    var.tags,
    {
      Name = format("%s-%s-ngw-eip", aws_vpc.vpc.tags["Name"], substr(each.key, -3, -1))
    }
  )
}
