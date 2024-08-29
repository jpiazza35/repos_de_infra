resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api_gw.id}/${var.api_gw_stage_name}"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}