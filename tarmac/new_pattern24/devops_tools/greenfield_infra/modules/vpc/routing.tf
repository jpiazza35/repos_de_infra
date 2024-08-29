resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    # Name       = format("%s Gateway", var.project)
    Name       = "igw-${var.tags["env"]}-${var.tags["vpc"]}"
    CostCentre = var.tags["costcentre"]
    Env        = var.tags["env"]
    Function   = "internet gateway"
    Repository = var.tags["repository"]
    Script     = var.tags["script"]
    Service    = var.tags["service"]
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc.id
  }

  tags = {
    Name       = "rtb-${var.tags["env"]}-${var.tags["vpc"]}-${var.region}-public"
    CostCentre = var.tags["costcentre"]
    Env        = var.tags["env"]
    Function   = "route table"
    Repository = var.tags["repository"]
    Script     = var.tags["script"]
    Service    = var.tags["service"]
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.vpc.id

  tags = {
    # Name       = format("%s Private", var.project)
    Name       = "rtb-${var.tags["env"]}-${var.tags["vpc"]}-${element(var.availability_zones, count.index)}-private"
    CostCentre = var.tags["costcentre"]
    Env        = var.tags["env"]
    Function   = "route table"
    Repository = var.tags["repository"]
    Script     = var.tags["script"]
    Service    = var.tags["service"]
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}