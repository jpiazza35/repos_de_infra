resource "aws_iam_policy" "force_mfa_policy" {
  count       = var.is_root_aws_account ? 1 : 0
  name        = "Force-MFA"
  description = "This policy allows users to manage their own passwords and MFA devices but nothing else unless they authenticate with MFA."
  path        = "/"
  policy      = data.template_file.user_iam_self_mfa_document.rendered

  tags = var.tags
}
