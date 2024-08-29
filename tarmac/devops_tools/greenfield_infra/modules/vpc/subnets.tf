resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    # Name = format("%s-public-%d", var.project, count.index + 1)
    Name       = "sub-${var.tags["env"]}-${var.tags["vpc"]}-${element(var.availability_zones, count.index)}-public-${count.index + 1}"
    CostCentre = var.tags["costcentre"]
    Env        = var.tags["env"]
    Function   = "subnet"
    Repository = var.tags["repository"]
    Script     = var.tags["script"]
    Service    = var.tags["service"]
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name       = "sub-${var.tags["env"]}-${var.tags["vpc"]}-${element(var.availability_zones, count.index)}-private-${count.index + 1}"
    CostCentre = var.tags["costcentre"]
    Env        = var.tags["env"]
    Function   = "subnet"
    Repository = var.tags["repository"]
    Script     = var.tags["script"]
    Service    = var.tags["service"]
  }
}
