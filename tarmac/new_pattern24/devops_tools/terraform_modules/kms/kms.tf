resource "aws_kms_key" "cloudtrail_kms_key" {
  count               = var.create_cloudtrail_key ? 1 : 0
  description         = "KMS Key used to encrypt Cloudtrails."
  enable_key_rotation = var.enable_key_rotation
  policy              = data.template_file.cloudtrail_kms_policy.rendered

  tags = var.tags
}

resource "aws_kms_alias" "cloudtrail_kms_key" {
  count         = var.create_cloudtrail_key ? 1 : 0
  name          = "alias/${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-cloudtrail-key"
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
  name          = "alias/${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-cw-log-groups-key"
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
  name          = "alias/${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-sqs-key"
  target_key_id = aws_kms_key.sqs_kms_key[count.index].key_id
}

resource "aws_kms_key" "s3_kms_key" {
  count               = var.create_s3_key ? 1 : 0
  description         = "KMS Key used to encrypt S3 buckets."
  enable_key_rotation = var.enable_key_rotation
  policy              = data.template_file.s3_kms_policy.rendered

  tags = var.tags
}

resource "aws_kms_alias" "s3_kms_key" {
  count         = var.create_s3_key ? 1 : 0
  name          = "alias/${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-s3-key"
  target_key_id = aws_kms_key.s3_kms_key[count.index].key_id
}

resource "aws_kms_key" "sns_kms_key" {
  count               = var.create_sns_key ? 1 : 0
  description         = "KMS Key used to encrypt SNS Topics."
  enable_key_rotation = var.enable_key_rotation
  policy              = var.is_logging ? data.template_file.sns_kms_policy_logging.rendered : data.template_file.sns_kms_policy.rendered

  tags = var.tags
}

resource "aws_kms_alias" "sns_kms_key" {
  count         = var.create_sns_key ? 1 : 0
  name          = "alias/${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-sns-key"
  target_key_id = aws_kms_key.sns_kms_key[count.index].key_id
}