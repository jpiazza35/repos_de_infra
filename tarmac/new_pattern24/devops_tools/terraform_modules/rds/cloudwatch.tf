resource "aws_cloudwatch_log_group" "user_creation" {
  name              = "/aws/lambda/${var.tags["Environment"]}-${var.tags["Product"]}-rds-user-creation"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "sql_automation" {
  name              = "/aws/lambda/${var.tags["Environment"]}-${var.tags["Product"]}-rds-sql-automation"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "rds_clean_up" {
  count             = var.create_ci_cd_lambdas ? 1 : 0
  name              = "/aws/lambda/${var.tags["Environment"]}-${var.tags["Product"]}-rds-clean-up"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}
