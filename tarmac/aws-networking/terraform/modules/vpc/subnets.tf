# Create transit subnets
resource "aws_subnet" "transit" {
  count = var.attach_to_tgw ? min(length(local.aws_enabled_azs), local.az_max) : 0

  vpc_id               = aws_vpc.vpc.id
  availability_zone_id = element(local.aws_enabled_azs, count.index)
  cidr_block           = cidrsubnet(var.vpc_cidr, 5, count.index + 1)

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s-transit", aws_vpc.vpc.tags["Name"], substr(element(local.aws_enabled_azs, count.index), -3, -1))
      Layer          = "transit"
      vpc            = aws_vpc.vpc.id
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}

# Create private subnets
resource "aws_subnet" "private" {
  count = min(length(local.aws_enabled_azs), local.az_max)

  vpc_id               = aws_vpc.vpc.id
  availability_zone_id = element(local.aws_enabled_azs, count.index)
  cidr_block           = cidrsubnet(var.vpc_cidr, 3, count.index + 1)

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s-private", aws_vpc.vpc.tags["Name"], substr(element(local.aws_enabled_azs, count.index), -3, -1))
      Layer          = "private"
      vpc            = aws_vpc.vpc.id
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}

# Create public subnets
resource "aws_subnet" "public" {
  count = var.enable_public_subnets ? min(length(local.aws_enabled_azs), local.az_max) : 0

  vpc_id               = aws_vpc.vpc.id
  availability_zone_id = element(local.aws_enabled_azs, count.index)
  cidr_block           = cidrsubnet(var.vpc_cidr, 3, count.index + 5)

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s-public", aws_vpc.vpc.tags["Name"], substr(element(local.aws_enabled_azs, count.index), -3, -1))
      Layer          = "public"
      vpc            = aws_vpc.vpc.id
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}
