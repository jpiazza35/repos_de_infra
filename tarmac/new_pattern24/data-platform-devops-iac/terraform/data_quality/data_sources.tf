data "aws_vpc_endpoint" "s3" {
  tags = {
    Name      = "s3-interface"
    Component = "networking"
  }
}

data "aws_network_interface" "s3" {
  for_each = data.aws_vpc_endpoint.s3.network_interface_ids
  id       = each.value
}

data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [
      "primary-vpc"
    ]
  }
}

data "aws_route53_zone" "selected" {
  provider     = aws.ss_network
  name         = var.dns_name
  private_zone = false
}