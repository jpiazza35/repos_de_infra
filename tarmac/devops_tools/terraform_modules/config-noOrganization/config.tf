resource "aws_config_configuration_recorder" "recorder" {
  name     = "config-recorder"
  role_arn = aws_iam_role.config_iam_role.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "config_channel" {
  s3_bucket_name = aws_s3_bucket.s3_conf.id
  depends_on     = [aws_config_configuration_recorder.recorder]
}

# -----------------------------------------------------------
# Enable AWS Config Recorder
# -----------------------------------------------------------
resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = aws_config_configuration_recorder.recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_channel]
}
