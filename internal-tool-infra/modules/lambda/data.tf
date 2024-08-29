data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_secretsmanager_secret" "slack_webhook_secret" {
  name = "/${var.lambda_environment}/${var.lambda_project}/LAMBDA_SLACK_WEBHOOK"
}

data "aws_secretsmanager_secret_version" "slack_webhook_secret_version" {
  secret_id = data.aws_secretsmanager_secret.slack_webhook_secret.id
}
