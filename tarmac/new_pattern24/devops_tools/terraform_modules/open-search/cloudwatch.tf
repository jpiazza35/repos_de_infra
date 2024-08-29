resource "aws_cloudwatch_log_group" "os_cloud_trail_logs" {
  count             = var.send_cloudtrail_logs ? 1 : 0
  name              = "/aws/cloudtrail/${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-os-log-group"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_subscription_filter" "lambda_os" {
  count = var.send_cloudtrail_logs ? 1 : 0

  name            = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-logs-to-os"
  log_group_name  = element(concat(aws_cloudwatch_log_group.os_cloud_trail_logs.*.name, tolist([""])), 0)
  filter_pattern  = ""
  destination_arn = element(concat(aws_lambda_function.logs_to_os.*.arn, tolist([""])), 0)
  distribution    = "Random"

}

resource "aws_cloudwatch_log_group" "logs_to_os" {
  count             = var.send_cloudtrail_logs ? 1 : 0
  name              = "/aws/lambda/${element(concat(aws_lambda_function.logs_to_os.*.function_name, tolist([""])), 0)}"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}