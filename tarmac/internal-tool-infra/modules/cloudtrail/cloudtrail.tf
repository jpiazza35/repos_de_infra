resource "aws_cloudtrail" "internal" {
  name                          = "${var.tags["Name"]}-${var.tags["Environment"]}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.s3_cloudtrail.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true

  depends_on = [
    aws_s3_bucket_policy.policy_cloudtrail
  ]

  tags = var.tags

}

resource "aws_s3_bucket" "s3_cloudtrail" {
  bucket        = "${var.tags["Name"]}-cloudtrail-${var.tags["Environment"]}"
  force_destroy = true

  tags = var.tags

}

resource "aws_s3_bucket_policy" "policy_cloudtrail" {
  bucket = aws_s3_bucket.s3_cloudtrail.id
  policy = data.aws_iam_policy_document.policy_cloudtrail.json

}

