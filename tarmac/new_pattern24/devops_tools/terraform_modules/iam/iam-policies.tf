resource "aws_iam_policy" "list_org_accounts" {
  count       = var.is_root_aws_account ? 1 : 0
  name        = "CloudWatch-CrossAccountSharing-ListAccounts-Policy"
  description = "This policy allows Logging & Monitoring account to list other accounts in the organization."
  path        = "/"
  policy      = data.template_file.list_org_accounts.rendered

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "list_org_accounts" {
  count      = var.is_root_aws_account ? 1 : 0
  role       = aws_iam_role.list_org_accounts[count.index].name
  policy_arn = aws_iam_policy.list_org_accounts[count.index].arn
}