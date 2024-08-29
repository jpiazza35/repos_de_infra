data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ab_role_assume_role_policy" {
  count = local.iam
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ab_tag_policy_document" {
  count = local.iam
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "backup:TagResource",
      "backup:ListTags",
      "backup:UntagResource",
      "tag:GetResources"
    ]
  }
}
