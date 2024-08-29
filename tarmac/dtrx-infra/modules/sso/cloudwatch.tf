resource "aws_cloudwatch_log_group" "user_inactivity" {
  count             = var.create_lambda_resources ? 1 : 0
  name              = "/aws/lambda/${var.tags["Environment"]}-sso-user-inactivity"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "password_expiration" {
  count             = var.create_lambda_resources ? 1 : 0
  name              = "/aws/lambda/${var.tags["Environment"]}-sso-password-expiration"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "dyndb_add_user" {
  count             = var.create_lambda_resources ? 1 : 0
  name              = "/aws/lambda/${var.tags["Environment"]}-dynamodb-add-user"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "dyndb_remove_user" {
  count             = var.create_lambda_resources ? 1 : 0
  name              = "/aws/lambda/${var.tags["Environment"]}-dynamodb-remove-user"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}
