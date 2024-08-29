# Create transit subnets
resource "aws_subnet" "transit" {
  count = var.attach_to_tgw ? min(length(local.subnet_azs), var.vpc_parameters["max_subnet_count"]) : 0

  vpc_id = aws_vpc.vpc.id
  availability_zone_id = element(
    local.subnet_azs, count.index
  )
  cidr_block = cidrsubnet(
    var.vpc_cidr, 5, count.index + 1
  )

  tags = merge(
    var.tags,
    {
      Name = format(
        "%s-%s-transit",
        aws_vpc.vpc.tags["Name"],
        substr(
          element(
            local.subnet_azs, count.index
          ), -3, -1
        )
      )
      Layer          = "transit"
      vpc            = aws_vpc.vpc.id
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}

# Create private subnets
resource "aws_subnet" "private" {
  count = min(length(local.subnet_azs), var.vpc_parameters["max_subnet_count"])

  vpc_id               = aws_vpc.vpc.id
  availability_zone_id = element(local.subnet_azs, count.index)
  cidr_block = cidrsubnet(
    var.vpc_cidr, 3, count.index + 1
  )

  tags = merge(
    var.tags,
    {
      Name = format(
        "%s-%s-private",
        aws_vpc.vpc.tags["Name"],
        substr(
          element(
            local.subnet_azs, count.index
          ), -3, -1
        )
      )
      Layer          = "private"
      vpc            = aws_vpc.vpc.id
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}

# Create public subnets
resource "aws_subnet" "public" {
  count = var.enable_public_subnets ? min(
    length(
      local.subnet_azs
    ),
    var.vpc_parameters["max_subnet_count"]
  ) : 0

  vpc_id               = aws_vpc.vpc.id
  availability_zone_id = element(local.subnet_azs, count.index)
  cidr_block           = cidrsubnet(var.vpc_cidr, 3, count.index + 5)

  tags = merge(
    var.tags,
    {
      Name           = format("%s-%s-public", aws_vpc.vpc.tags["Name"], substr(element(local.subnet_azs, count.index), -3, -1))
      Layer          = "public"
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}

# Create local subnets
resource "aws_subnet" "local" {
  count = var.enable_secondary_cidr ? min(
    length(
      local.subnet_azs
    ),
    var.vpc_parameters["max_subnet_count"]
  ) : 0

  vpc_id               = aws_vpc_ipv4_cidr_block_association.secondary_cidr[0].vpc_id
  availability_zone_id = element(local.subnet_azs, count.index)
  cidr_block           = cidrsubnet(var.vpc_parameters["networking"]["secondary_cidr_block"], 2, count.index + 1)

  tags = merge(
    var.tags,
    {
      Name = format(
        "%s-%s-local",
        aws_vpc.vpc.tags["Name"],
        substr(element(
          local.subnet_azs,
          count.index
      ), -3, -1))
      Layer          = "local"
      vpc            = aws_vpc.vpc.id
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}
