resource "aws_cloudtrail" "pipeline_trail" {
  count                         = var.create_pipeline_trail ? 1 : 0
  name                          = "${var.tags["Environment"]}-${var.tags["Product"]}-codepipeline-source-trail"
  s3_bucket_name                = element(concat(aws_s3_bucket.s3_cloud_trail_logs.*.id, tolist([""])), 0)
  include_global_service_events = false
  cloud_watch_logs_group_arn    = "${element(concat(aws_cloudwatch_log_group.pipeline_trail.*.arn, tolist([""])), 0)}:*"
  cloud_watch_logs_role_arn     = element(concat(aws_iam_role.cloudtrail_cw_logs.*.arn, tolist([""])), 0)
  enable_log_file_validation    = var.cloudtrail_enable_log_file_validation

  event_selector {
    read_write_type           = "WriteOnly"
    include_management_events = false

    data_resource {
      type   = "AWS::S3::Object"
      values = var.pipeline_source_s3_bucket_arns
    }
  }

  kms_key_id = var.cloudtrail_kms_key_arn

  depends_on = [
    aws_s3_bucket_policy.s3_cloud_trail_logs,
    aws_s3_bucket.s3_cloud_trail_logs
  ]
}

resource "aws_cloudwatch_log_group" "pipeline_trail" {
  count             = var.create_pipeline_trail ? 1 : 0
  name              = "/aws/cloudtrail/${var.tags["Environment"]}-${var.tags["Product"]}-codepipeline-source-trail"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days
}