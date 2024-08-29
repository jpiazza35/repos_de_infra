resource "aws_s3_bucket" "logs" {
  count  = local.default
  bucket = format("%s-lb-access-logs-%s", lower(var.env), var.app)

  tags = {
    Name        = format("%s-lb-access-logs-%s", lower(var.env), var.app)
    Environment = lower(var.env)
  }
}

resource "aws_s3_bucket_policy" "default" {
  count  = local.default
  bucket = aws_s3_bucket.logs[count.index].id
  policy = data.aws_iam_policy_document.default[count.index].json
}

data "aws_iam_policy_document" "default" {
  count = local.default
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        data.aws_elb_service_account.default[count.index].arn
      ]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${format("%s-lb-access-logs-%s", lower(var.env), var.app)}/*",
    ]
  }
}
