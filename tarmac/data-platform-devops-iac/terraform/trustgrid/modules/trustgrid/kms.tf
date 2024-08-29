resource "aws_kms_key" "key" {
  description             = format("%s %s KMS Key", title(var.app), title(var.env))
  deletion_window_in_days = 10

  policy = data.aws_iam_policy_document.kms.json

}

resource "aws_kms_alias" "key" {

  name          = "alias/${var.app}-${var.env}-kms"
  target_key_id = aws_kms_key.key.key_id
}

data "aws_iam_policy_document" "kms" {

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
        format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id),
        format("arn:aws:iam::%s:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling", data.aws_caller_identity.current.account_id)
      ]
    }
  }

  depends_on = [
    aws_iam_service_linked_role.asg
  ]
}
