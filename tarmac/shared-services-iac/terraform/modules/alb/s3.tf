resource "aws_s3_bucket" "logs" {
  count  = var.alb["access_logs"]["enabled"] ? 1 : 0
  bucket = format("%s-lb-access-logs-%s", lower(var.alb["env"]), lower(var.alb["app"]))

  tags = {
    Name        = format("%s-lb-access-logs-%s", lower(var.alb["env"]), lower(var.alb["app"]))
    Environment = lower(var.alb["env"])
  }
}

resource "aws_s3_bucket_policy" "default" {
  count = var.alb["access_logs"]["enabled"] ? 1 : 0

  bucket = aws_s3_bucket.logs[count.index].id
  policy = data.aws_iam_policy_document.default[count.index].json
}

data "aws_iam_policy_document" "default" {
  count = var.alb["access_logs"]["enabled"] ? 1 : 0
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
      "arn:aws:s3:::${format("%s-lb-access-logs-%s", lower(var.alb["env"]), lower(var.alb["app"]))}/*",
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
      "arn:aws:s3:::${format("%s-lb-access-logs-%s", lower(var.alb["env"]), lower(var.alb["app"]))}",
    ]
  }

  statement {
    sid = "AWSLogDeliveryWrite"
    actions = [
      "s3:PutObject"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${format("%s-lb-access-logs-%s", lower(var.alb["env"]), lower(var.alb["app"]))}/*"
    ]

    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}
