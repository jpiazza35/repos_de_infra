data "aws_caller_identity" "current" {
  count = local.default
}

data "aws_region" "current" {
  count = local.default
}

data "aws_vpc" "vpc" {
  count = local.default
  filter {
    name = "tag:Name"
    values = [
      "primary-vpc"
    ]
  }
}

data "aws_subnets" "public" {
  count = local.default
  filter {
    name = "tag:Layer"
    values = [
      "public"
    ]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public[0].ids)
  id       = each.value
}

data "aws_subnets" "private" {
  count = local.default
  filter {
    name = "tag:Layer"
    values = [
      "private"
    ]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private[0].ids)
  id       = each.value
}

data "aws_ami" "ubuntu" {
  count       = local.default
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
