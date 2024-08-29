resource "aws_kms_key" "key" {
  count                   = local.default
  description             = "vault Worker KMS key"
  deletion_window_in_days = 10

  policy = data.aws_iam_policy_document.kms[count.index].json

}

resource "aws_kms_alias" "key" {
  count         = local.default
  name          = "alias/${var.app}-${var.env}-kms"
  target_key_id = aws_kms_key.key[count.index].key_id
}

data "aws_iam_policy_document" "kms" {
  count = local.default
  statement {
    sid    = "Allow KMS Use"
    effect = "Allow"
    actions = [
      "kms:*",
    ]
    resources = [
      "*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        format("arn:aws:iam::%s:root", data.aws_caller_identity.current[count.index].account_id),
        format("arn:aws:iam::%s:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", data.aws_caller_identity.current[count.index].account_id)
      ]
    }
  }
}
