data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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

# Task role assume policy
data "aws_iam_policy_document" "task_assume" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Task logging privileges
data "aws_iam_policy_document" "task_permissions" {

  statement {
    effect = "Allow"

    resources = [
      aws_cloudwatch_log_group.main.arn,
      "${aws_cloudwatch_log_group.main.arn}:*"
    ]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

# Task permissions to allow ECS Exec command
data "aws_iam_policy_document" "task_ecs_exec_policy" {

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
  }
  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances",
      "ssm:DescribeInstanceInformation"
    ]
  }
}

# Task ecr privileges
data "aws_iam_policy_document" "task_execution_permissions" {

  statement {
    effect = "Allow"

    resources = [
      "*",
    ]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:*",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "cloudwatch:*",
      "logs:*",
      "secretsmanager:*"
    ]
  }
}

data "aws_iam_policy_document" "read_repository_credentials" {

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
    ]
  }
}

data "aws_iam_policy_document" "get_environment_files" {
  count = length(local.get_env_files) > 0 ? 1 : 0
  statement {
    effect = "Allow"

    resources = local.get_env_files

    actions = [
      "s3:GetObject"
    ]
  }

  statement {
    effect = "Allow"

    resources = local.get_env_files

    actions = [
      "s3:GetBucketLocation"
    ]
  }
}

data "aws_elb_service_account" "default" {}


data "aws_ecs_task_definition" "task" {
  for_each = aws_ecs_task_definition.task

  task_definition = each.value.family
}

/* data "aws_ecs_service" "example" {
  service_name = "example"
  cluster_arn  = data.aws_ecs_cluster.example.arn
} */
