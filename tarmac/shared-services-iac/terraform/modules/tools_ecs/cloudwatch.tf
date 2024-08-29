resource "aws_cloudwatch_log_group" "main" {
  count = local.default
  name  = format("%s-cw-logs", lower(var.env))

  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.logs_kms_key

  tags = var.tags
}
