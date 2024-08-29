# AWS Managed IAM policies attachments

# This needs to be changed when permissions will be split - add except SSO permissions
resource "aws_iam_group_policy_attachment" "admin" {
  count      = var.is_root_aws_account ? 1 : 0
  group      = aws_iam_group.admin[count.index].name
  policy_arn = data.aws_iam_policy.AdminAccess.arn
}

resource "aws_iam_group_policy_attachment" "readonly" {
  count      = var.is_root_aws_account ? 1 : 0
  group      = aws_iam_group.readonly[count.index].name
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
}

resource "aws_iam_group_policy_attachment" "billing" {
  count      = var.is_root_aws_account ? 1 : 0
  group      = aws_iam_group.billing[count.index].name
  policy_arn = data.aws_iam_policy.BillingAccess.arn
}

resource "aws_iam_group_policy_attachment" "iam_change_password" {
  count      = var.is_root_aws_account ? 1 : 0
  group      = aws_iam_group.iam_change_password[count.index].name
  policy_arn = data.aws_iam_policy.IAMChangePassword.arn
}

# Terraform created IAM policies attachments
resource "aws_iam_group_policy_attachment" "force_mfa_admin_attach" {
  count      = var.is_root_aws_account ? 1 : 0
  group      = aws_iam_group.admin[count.index].name
  policy_arn = aws_iam_policy.force_mfa_policy[count.index].arn
}

resource "aws_iam_group_policy_attachment" "force_mfa_readonly_attach" {
  count      = var.is_root_aws_account ? 1 : 0
  group      = aws_iam_group.readonly[count.index].name
  policy_arn = aws_iam_policy.force_mfa_policy[count.index].arn
}
