# Add secondary CIDR
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  count      = var.enable_secondary_cidr ? 1 : 0
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.secondary_cidr
}

# Create local subnets
resource "aws_subnet" "local" {
  count = var.enable_secondary_cidr ? min(length(local.aws_enabled_azs), local.az_max) : 0

  vpc_id               = aws_vpc.vpc.id
  availability_zone_id = element(local.aws_enabled_azs, count.index)
  cidr_block           = cidrsubnet(var.vpc_cidr, 2, count.index + 1)

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s-local", aws_vpc.vpc.tags["Name"], substr(element(local.aws_enabled_azs, count.index), -3, -1))
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )
}
