resource "aws_cloudwatch_log_group" "waf_log_group" {
  count             = var.create_waf_log_configuration ? 1 : 0
  name              = "aws-waf-logs-${var.tags["Environment"]}-${var.tags["Application"]}"
  kms_key_id        = var.waf_log_groups_kms_key_arn
  retention_in_days = var.waf_retention_in_days

  tags = var.tags
}