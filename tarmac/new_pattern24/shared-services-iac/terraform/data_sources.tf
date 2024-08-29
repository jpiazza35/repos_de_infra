locals {
  default = terraform.workspace == "sharedservices" ? 1 : 0

  ## subnets slice for EFS mounts
  selected_subnet_id_0 = element(data.aws_subnets.all[0].ids, 0)
  selected_subnet_id_1 = element(data.aws_subnets.all[0].ids, 1)
  selected_subnet_id_2 = element(data.aws_subnets.all[0].ids, 2)
}

resource "null_resource" "tf_workspace_validator" {
  lifecycle {
    precondition {
      condition     = terraform.workspace == "sharedservices"
      error_message = "SANITY CHECK: This is a sensitive project. Your current workspace is '${terraform.workspace}'. You must be in the 'sharedservices' workspace to apply this terraform."
    }
  }
}

data "aws_iam_policy_document" "github" {
  count = terraform.workspace == "sharedservices" ? 1 : 0
  statement {
    actions = [
      "iam:*",
      "cloudwatch:*",
      "ecs:*",
      "ec2:*",
      "rds:*",
      "secretsmanager:*",
      "acm:*",
      "route53:*",
      "kms:*",
      "s3:*",
      "ssm:*",
      "ecr:*",
      "logs:*",
      "lambda:*",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "servicediscovery:*",
      "elasticloadbalancing:*",
      "sns:*",
      "autoscaling:*",
      "eks:*",
      "elasticfilesystem:*"
    ]
    resources = ["*"]
  }
}

data "aws_vpc" "vpc" {
  count = local.default
  tags = {
    Name = "primary-vpc"
  }
}

data "aws_subnets" "all" {
  count = local.default
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc[count.index].id
    ]
  }
  tags = {
    Layer = "private"
  }
}

data "aws_subnets" "public" {
  count = local.default
  filter {
    name = "vpc-id"
    values = [
      data.aws_vpc.vpc[count.index].id
    ]
  }
  tags = {
    Layer = "public"
  }
}

# PHPIPAM

data "aws_secretsmanager_secret" "secret" {
  count = local.default
  name  = "phpIPAM"
}

data "aws_secretsmanager_secret_version" "secret" {
  count     = local.default
  secret_id = data.aws_secretsmanager_secret.secret[count.index].id
}

# Sonatype

data "aws_secretsmanager_secret" "sonatype_secret" {
  count = local.default
  name  = "sonatype"
}

data "aws_secretsmanager_secret_version" "sonatype_secret_version" {
  count     = local.default
  secret_id = data.aws_secretsmanager_secret.sonatype_secret[count.index].id
}
