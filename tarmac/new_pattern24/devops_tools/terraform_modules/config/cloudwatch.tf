resource "aws_cloudwatch_log_group" "config_compliance_lambda" {
  count             = var.create_lambda_resources ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.config_compliance_lambda[count.index].function_name}"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_subscription_filter" "config_compliance_lambda" {
  count           = var.create_lambda_resources ? 1 : 0
  name            = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-config-rules-compliance-to-os"
  log_group_name  = aws_cloudwatch_log_group.config_compliance_lambda[count.index].name
  filter_pattern  = ""
  destination_arn = var.lambda_to_os_arn
  distribution    = "Random"
}
