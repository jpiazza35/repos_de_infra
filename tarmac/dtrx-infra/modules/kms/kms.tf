resource "aws_kms_key" "cloudtrail_kms_key" {
  count               = var.create_cloudtrail_key ? 1 : 0
  description         = "KMS Key used to encrypt Cloudtrails."
  enable_key_rotation = var.enable_key_rotation
  policy              = data.template_file.cloudtrail_kms_policy.rendered

  tags = var.tags
}

resource "aws_kms_alias" "cloudtrail_kms_key" {
  count         = var.create_cloudtrail_key ? 1 : 0
  name          = "alias/${var.tags["Environment"]}-cloudtrail-key"
  target_key_id = aws_kms_key.cloudtrail_kms_key[0].key_id
}

resource "aws_kms_key" "cw_log_groups_kms_key" {
  count               = var.create_cw_log_groups_key ? 1 : 0
  description         = "KMS Key used to encrypt Cloudwatch log groups."
  enable_key_rotation = var.enable_key_rotation
  policy              = data.template_file.cw_log_groups_kms_policy.rendered

  tags = var.tags
}

resource "aws_kms_alias" "cw_log_groups_kms_key" {
  count         = var.create_cw_log_groups_key ? 1 : 0
  name          = "alias/${var.tags["Environment"]}-cw-log-groups-key"
  target_key_id = aws_kms_key.cw_log_groups_kms_key[0].key_id
}

resource "aws_kms_key" "sqs_kms_key" {
  count               = var.create_sqs_key ? 1 : 0
  description         = "KMS Key used to encrypt SQS queues."
  enable_key_rotation = var.enable_key_rotation
  policy              = data.template_file.sqs_kms_policy.rendered

  tags = var.tags
}

resource "aws_kms_alias" "sqs_kms_key" {
  count         = var.create_sqs_key ? 1 : 0
  name          = "alias/${var.tags["Environment"]}-sqs-key"
  target_key_id = aws_kms_key.sqs_kms_key[count.index].key_id
}