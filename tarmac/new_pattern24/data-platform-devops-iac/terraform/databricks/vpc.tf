variable "enable_secondary_cidr" {
  default = true
}

variable "vpc_parameters" {
  default = {
    max_subnet_count = 3
    networking = {
      secondary_cidr_block = "10.202.64.0/22"
    }
  }
}

data "aws_region" "current" {}
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["primary-vpc"]
  }
}

locals {
  subnet_azs = data.aws_region.current.name == "us-east-1" ? [
    "use1-az1",
    "use1-az5",
    "use1-az6"
    ] : [
    "use2-az1",
    "use2-az2",
    "use2-az3",
  ]
}


### Resources for a Routable Secondary CIDR Range to be used by Databricks

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  count      = var.enable_secondary_cidr ? 1 : 0
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = var.vpc_parameters["networking"]["secondary_cidr_block"]
}

# Create subnets for secondary CIDR
resource "aws_subnet" "secondary" {
  count = var.enable_secondary_cidr ? min(
    length(
      local.subnet_azs
    ),
    var.vpc_parameters["max_subnet_count"]
  ) : 0

  vpc_id               = aws_vpc_ipv4_cidr_block_association.secondary_cidr[0].vpc_id
  availability_zone_id = element(local.subnet_azs, count.index)
  cidr_block           = cidrsubnet(var.vpc_parameters["networking"]["secondary_cidr_block"], 2, count.index + 1)

  tags = {
    Name = format(
      "%s-%s-secondary",
      data.aws_vpc.vpc.tags["Name"],
      substr(element(
        local.subnet_azs,
        count.index
    ), -3, -1))
    Layer          = "databricks"
    vpc            = data.aws_vpc.vpc.id
    SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
  }
}

# resource "aws_route_table" "secondary" {
#     count = var.enable_secondary_cidr ? min(
#         length(
#         local.subnet_azs
#         ),
#         var.vpc_parameters["max_subnet_count"]
#     ) : 0

#   vpc_id = data.aws_vpc.vpc.id

#   tags = {
#     Name = "private-secondary-route-table"
#   }
# }

# resource "aws_route_table_association" "secondary" {
#   subnet_id      = aws_subnet.foo.id
#   route_table_id = aws_route_table.bar.id
# }