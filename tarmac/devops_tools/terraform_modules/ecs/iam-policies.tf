# IAM policy that will be attached to the ECS services IAM roles and allow them access to the Shared Services ECR repos
resource "aws_iam_policy" "assume_ecr_shared_services" {
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-assume-role-ecr-shared-services"
  description = "This policy allows the ECS IAM roles to assume a role in the Shared Services account and pull images from ECR."
  path        = "/"
  policy      = data.template_file.assume_ecr_shared_services.rendered

  tags = var.tags
}

# Attach AmazonECSTaskExecutionRolePolicy permission to the ECS services IAM roles
resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.ecs_task_execution_policy
}

# Attach the IAM policy that gives ECR assume role permission to the ECS services IAM roles
resource "aws_iam_role_policy_attachment" "assume_ecr_shared_services" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.assume_ecr_shared_services.arn
}

# IAM policy allowing ECS to access AWS SecretsManager via the VPC endpoint only
resource "aws_iam_policy" "secretsmanager_access" {
  count       = var.create_secrets_iam ? 1 : 0
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-allow-secretsmanager-access"
  description = "This policy allows the ECS IAM roles to have access to AWS SecretsManager via the VPC."
  path        = "/"
  policy      = data.template_file.secretsmanager_access.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "secretsmanager_access" {
  count      = var.create_secrets_iam ? 1 : 0
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.secretsmanager_access[0].arn
}

# IAM policy allowing ECS to access AWS S3 via the VPC endpoint only
resource "aws_iam_policy" "s3_access" {
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-allow-s3-access"
  description = "This policy allows the ECS IAM roles to have access to AWS S3 via the VPC."
  path        = "/"
  policy      = data.template_file.s3_access.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# IAM policy allowing ECS to access AWS ECS
resource "aws_iam_policy" "ecs_access" {
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-allow-ecs-access"
  description = "This policy allows the ECS IAM roles to have access to AWS ECS."
  path        = "/"
  policy      = data.template_file.ecs_access.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_access" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.ecs_access.arn
}

# Attach CloudWatchAgentServerPolicy policy to the ECS services IAM roles
resource "aws_iam_role_policy_attachment" "cw_agent_server" {
  role       = aws_iam_role.ecs.name
  policy_arn = var.cw_agent_server_policy_arn
}

# IAM policy allowing ECS to access AWS RDS via IAM auth
resource "aws_iam_policy" "rds_access" {
  count = var.create_rds_iam_auth ? 1 : 0

  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-allow-rds-access"
  description = "This policy allows the ECS IAM roles to have access to AWS RDS via IAM auth."
  path        = "/"
  policy      = data.template_file.rds_access.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_access" {
  count = var.create_rds_iam_auth ? 1 : 0

  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.rds_access[count.index].arn
}

# IAM policy allowing ECS role to access AWS KMS
resource "aws_iam_policy" "kms_access" {
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-allow-kms-access"
  description = "This policy allows the ECS IAM roles to have access to AWS KMS."
  path        = "/"
  policy      = data.template_file.kms_access.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "kms_access" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.kms_access.arn
}