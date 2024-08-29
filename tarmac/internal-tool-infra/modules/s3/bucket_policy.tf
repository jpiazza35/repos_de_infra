data "aws_iam_policy_document" "internal_tool_user_s3_access" {

  statement {
    sid = "PolicyForCloudFrontPrivateContent"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        var.cloudfront_distribution_arn
      ]
    }
  }
  statement {

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_acc_id}:user/internal-tool-user"]
    }

    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
      "arn:aws:s3:::${var.s3_bucket_name}"
    ]
  }
}