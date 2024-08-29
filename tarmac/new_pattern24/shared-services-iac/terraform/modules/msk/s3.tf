resource "aws_s3_bucket" "logs" {
  count  = var.access_logs["enabled"] ? 1 : 0
  bucket = format("%s-msk-cluster-logs-%s", lower(var.env), lower(var.app))

  tags = {
    Name        = format("%s-msk-cluster-logs-%s", lower(var.env), lower(var.app))
    Environment = lower(var.env)
  }
}

resource "aws_s3_bucket_public_access_block" "access" {
  count  = var.access_logs["enabled"] ? 1 : 0
  bucket = aws_s3_bucket.logs[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "default" {
  count = var.access_logs["enabled"] ? 1 : 0

  bucket = aws_s3_bucket.logs[count.index].id
  policy = data.aws_iam_policy_document.default[count.index].json
}

data "aws_iam_policy_document" "default" {
  count = var.access_logs["enabled"] ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        data.aws_elb_service_account.default.arn
      ]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${format("%s-msk-cluster-logs-%s", lower(var.env), lower(var.app))}/*",
    ]
  }

  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "arn:aws:s3:::${format("%s-msk-cluster-logs-%s", lower(var.env), lower(var.app))}",
    ]
  }

  statement {
    sid = "AWSLogDeliveryWrite"
    actions = [
      "s3:PutObject"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${format("%s-msk-cluster-logs-%s", lower(var.env), lower(var.app))}/*"
    ]

    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}
