data "aws_caller_identity" "source" {
  provider = aws.source
}

data "aws_caller_identity" "target" {
  provider = aws.target
}

data "aws_region" "current" {
  provider = aws.target
}

data "aws_iam_policy_document" "assume_role" {
  provider = aws.target
  count    = local.create_aws_auth
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.source.account_id
      ]
    }
  }
}

data "aws_iam_policy_document" "aws_auth" {
  provider = aws.target
  count    = local.create_aws_auth
  statement {
    sid = "vaultawsauth"
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:ListRoles",
      "iam:GetRole"
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_vpc" "vpc" {
  provider = aws.target
  count    = var.vpc_ids == null ? local.create_aws_auth : 0
  filter {
    name = "tag:Name"
    values = [
      "primary-vpc"
    ]
  }
}

data "aws_subnets" "private" {
  provider = aws.target
  count    = var.vpc_ids == null ? local.create_aws_auth : 0
  filter {
    name = "tag:Layer"
    values = [
      "private"
    ]
  }
}

## Assume Role in Vault Source Account (SS_TOOLS)
data "aws_iam_policy_document" "aws_auth_source" {
  provider = aws.source
  count    = local.create_aws_auth
  statement {
    sid = "vaultawsauth"
    actions = [
      "ec2:DescribeInstances",
      "iam:GetInstanceProfile",
      "iam:ListRoles",
      "iam:GetRole"
    ]
    resources = [
      "*",
    ]
  }
  statement {
    sid = "crossaccount"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      aws_iam_role.aws_auth[count.index].arn,
    ]
  }
}

data "aws_iam_policy_document" "assume_role_source" {
  provider = aws.source
  count    = local.create_aws_auth
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.source.account_id}:root",
      ]
    }

    actions = ["sts:AssumeRole"]
  }

}
