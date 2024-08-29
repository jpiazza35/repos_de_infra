data "aws_vpc" "vpc" {
  tags = {
    Name = "primary-vpc"
  }
}

data "aws_subnets" "private" {
  tags = {
    Layer = "private"
  }
}

data "aws_elb_service_account" "default" {}
