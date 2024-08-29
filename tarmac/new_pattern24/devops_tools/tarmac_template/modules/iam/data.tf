
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


data "aws_iam_policy" "instance_secret_manager_policy" {
  arn = var.instance_secret_manager_policy_arn
}
data "aws_iam_policy_document" "instance_secret_manager_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bucket_datalake" {
  statement {
    sid = "AccessDatalakeS3Policy"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetBucketLocation"
    ]
    resources = [
      "${var.datalake_bucket.arn}/*",
      "${var.datalake_bucket.arn}"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "bucket_scripts" {
  statement {
    sid = "AccessS3Scripts"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetBucketLocation"
    ]
    resources = [
      "${var.s3_bucket_scripts.arn}/*",
      "${var.s3_bucket_scripts.arn}"
    ]
    effect = "Allow"
  }
}

/*
data "aws_iam_policy_document" "load_balancer_bucket_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "load_balancer_bucket_putonly" {
  statement {
    sid = "loadBalancerAccessBucketLog"
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [
      "${var.load_balancer_bucket_log.arn}/AWSLogs/${var.load_balancer_account_id}/*"
    ]
    effect = "Allow"
  }
}

data "aws_iam_policy" "load_balancer_bucket_log_policy" {
  arn = var.load_balancer_arn
}*/