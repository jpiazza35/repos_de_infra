resource "aws_cloudwatch_log_group" "redis_clean_up" {
  count             = var.create_ci_cd_lambdas ? 1 : 0
  name              = "/aws/lambda/${var.tags["Environment"]}-${var.tags["Product"]}-redis-clean-up"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}
