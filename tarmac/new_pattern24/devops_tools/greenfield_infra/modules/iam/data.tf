data "aws_iam_policy_document" "distribution_invalidation" {
  statement {
    sid       = "CreateInvalidation"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["${var.s3_bucket_distribution.arn}"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "bucket_putonly" {
  statement {
    sid = "PutOnlyS3Policy"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetBucketLocation"
    ]
    resources = [
      "${var.s3_bucket.arn}/*",
      "${var.s3_bucket.arn}",
      "${var.s3_bucket_log.arn}/*",
      "${var.s3_bucket_log.arn}"
    ]
    effect = "Allow"
  }
}