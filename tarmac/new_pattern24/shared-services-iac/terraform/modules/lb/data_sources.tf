data "aws_elb_service_account" "default" {}

data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [
      "primary-vpc"
    ]
  }
}

data "aws_subnets" "public" {
  filter {
    name = "tag:Layer"
    values = [
      "public"
    ]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Layer"
    values = [
      "private"
    ]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}
