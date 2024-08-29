data "aws_region" "current" {
  count = local.default
}

# Task role assume policy
data "aws_iam_policy_document" "task_assume" {
  count = local.default
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
  count = local.default
  statement {
    effect = "Allow"

    resources = [
      aws_cloudwatch_log_group.main[count.index].arn,
      "${aws_cloudwatch_log_group.main[count.index].arn}:*"
    ]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

# Task permissions to allow ECS Exec command
data "aws_iam_policy_document" "task_ecs_exec_policy" {
  count = var.enable_execute_command && terraform.workspace == "sharedservices" ? 1 : 0

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
  count = local.default
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
      "logs:*"
    ]
  }
}

data "aws_kms_key" "secretsmanager_key" {
  count = var.create_repository_credentials_iam_policy && terraform.workspace == "sharedservices" ? 1 : 0

  key_id = var.repository_credentials_kms_key
}

data "aws_iam_policy_document" "read_repository_credentials" {
  count = var.create_repository_credentials_iam_policy && terraform.workspace == "sharedservices" ? 1 : 0

  statement {
    effect = "Allow"

    resources = [
      var.repository_credentials,
      data.aws_kms_key.secretsmanager_key[count.index].arn,
    ]

    actions = [
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
    ]
  }
}

data "aws_iam_policy_document" "get_environment_files" {
  count = length(var.task_container_environment_files) != 0 && terraform.workspace == "sharedservices" ? 1 : 0

  statement {
    effect = "Allow"

    resources = var.task_container_environment_files

    actions = [
      "s3:GetObject"
    ]
  }

  statement {
    effect = "Allow"

    resources = [for file in var.task_container_environment_files : split("/", file)[0]]

    actions = [
      "s3:GetBucketLocation"
    ]
  }
}

data "aws_elb_service_account" "default" {
  count = local.default
}


### phpipam
data "aws_ecs_task_definition" "task" {
  count           = local.default
  task_definition = aws_ecs_task_definition.task[count.index].family
}

data "aws_secretsmanager_secret" "rds_password" {
  count = local.default
  name  = "phpipam_rds_password"
}

data "aws_secretsmanager_secret_version" "rds_password" {
  count     = local.default
  secret_id = data.aws_secretsmanager_secret.rds_password[count.index].id
}


### sonatype artifactory

data "aws_ecs_task_definition" "sonatype_td" {
  count           = local.default
  task_definition = aws_ecs_task_definition.sonatype_td[count.index].family
}

# Task execution privileges
data "aws_iam_policy_document" "sonatype_task_execution_permissions" {
  count = local.default
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
      "s3:*"
    ]
  }
}

# task permissions

data "aws_iam_policy_document" "s3_task_policy" {
  count = local.default

  statement {
    sid       = "AllowBucketCreation"
    effect    = "Allow"
    actions   = ["s3:CreateBucket"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowPutObject"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutObjectTagging",
      "s3:GetObjectTagging",
      "s3:DeleteObjectTagging",
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::cn-nexus-s3-blobs-1/*",
      "arn:aws:s3:::cn-nexus-s3-blobs-1",
      "arn:aws:s3:::cn-nexus-s3-blobs-2/*",
      "arn:aws:s3:::cn-nexus-s3-blobs-2",
      "arn:aws:s3:::cn-nexus-s3-blobs-3/*",
      "arn:aws:s3:::cn-nexus-s3-blobs-3"
    ]
  }
}



### INCIDENT BOT

data "aws_ecs_task_definition" "incident_bot" {
  count           = local.default
  task_definition = aws_ecs_task_definition.incident_bot[count.index].family
}

data "aws_secretsmanager_secret" "incident_bot" {
  count = local.default
  name  = "incident_bot"
}

data "aws_secretsmanager_secret_version" "incident_bot" {
  count     = local.default
  secret_id = data.aws_secretsmanager_secret.incident_bot[count.index].id
}
