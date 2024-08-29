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
      var.ami_to_find["name"]
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [
    var.ami_to_find["owner"]
  ] # Canonical
}

data "aws_iam_policy_document" "ec2_assume_policy" {
  policy_id = "EC2Assume"
  statement {
    sid    = "AllowAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

