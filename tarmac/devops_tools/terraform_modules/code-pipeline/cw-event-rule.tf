resource "aws_cloudwatch_event_rule" "s3_pipeline_cwe" {
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-cw-event-rule"
  description = "Amazon CloudWatch Event rule to automatically start your pipeline when a change occurs in the Amazon S3 object key or S3 folder. "

  event_pattern = data.template_file.s3_cw_pipeline_source.rendered

  tags = var.tags
}