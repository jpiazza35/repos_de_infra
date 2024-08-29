resource "aws_cloudtrail" "os_cloud_trail_logs" {
  count                         = var.send_cloudtrail_logs ? 1 : 0
  name                          = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-os-logs"
  s3_bucket_name                = element(concat(aws_s3_bucket.s3_cloud_trail_logs.*.id, tolist([""])), 0)
  include_global_service_events = false
  cloud_watch_logs_group_arn    = "${element(concat(aws_cloudwatch_log_group.os_cloud_trail_logs.*.arn, tolist([""])), 0)}:*"
  cloud_watch_logs_role_arn     = element(concat(aws_iam_role.cloudtrail_cw_logs.*.arn, tolist([""])), 0)
  enable_log_file_validation    = var.cloudtrail_enable_log_file_validation

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  kms_key_id = var.cloudtrail_kms_key_arn

  depends_on = [
    aws_s3_bucket_policy.s3_cloud_trail_logs,
    aws_s3_bucket.s3_cloud_trail_logs
  ]
}