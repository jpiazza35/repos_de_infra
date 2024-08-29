data "aws_caller_identity" "current" {
}

data "aws_ecs_task_definition" "ecs" {
  count           = var.create_ecs_service ? 1 : 0
  task_definition = aws_ecs_task_definition.ecs[0].family
}

data "aws_ecs_task_definition" "ecs_prep_handler" {
  count           = var.create_preparation_handler ? 1 : 0
  task_definition = aws_ecs_task_definition.ecs_prep_handler[0].family
}

# Allows assume role to the IAM role in the Shared Services AWS account for ECR readonly
data "template_file" "assume_ecr_shared_services" {
  template = file("${path.module}/iam_policies/assume_ecr_shared_services.json")

  vars = {
    shared_services_account_id = var.shared_services_aws_account_id
  }
}

# Allows S3 access via VPC endpoint only
data "template_file" "s3_access" {
  template = file("${path.module}/iam_policies/s3_access.json")
  vars = {
    s3_vpc_endpoint_id = var.s3_vpc_endpoint_id
  }
}

# Allows ECS access
data "template_file" "ecs_access" {
  template = file("${path.module}/iam_policies/ecs_access.json")
}

# Allows RDS access via RDS IAM authentication
data "template_file" "rds_access" {
  template = file("${path.module}/iam_policies/rds_access.json")
  vars = {
    db_account_arn = var.db_account_arn
  }
}

# Allows SecretsManager access via VPC endpoint only
data "template_file" "secretsmanager_access" {
  template = file("${path.module}/iam_policies/secretsmanager_access.json")
  vars = {
    secrets_manager_secret_arn = var.secrets_manager_secret_arn
    secrets_vpc_endpoint_id    = var.secrets_vpc_endpoint_id
  }
}

# Allows KMS access
data "template_file" "kms_access" {
  template = file("${path.module}/iam_policies/kms_access.json")
}