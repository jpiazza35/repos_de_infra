# Create internet gateway for new VPC
resource "aws_internet_gateway" "primary" {
  count = var.enable_public_subnets ? 1 : 0

  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name           = format("%s-igw", aws_vpc.vpc.tags["Name"])
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}
