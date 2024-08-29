data "aws_caller_identity" "current" {
}

data "aws_iam_role" "ec2_instance_role" {
  name = var.iam_instance_profile
}

data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [
      var.vpc_name
    ]
  }
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Layer"
    values = [
      "private"
    ]
  }
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name = "name"
    values = [
      var.ami_to_find["name"]
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [
    var.ami_to_find["owner"]
  ]
}

data "aws_iam_instance_profile" "instance_profile" {
  name = var.iam_instance_profile
}
