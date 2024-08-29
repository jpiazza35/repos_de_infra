# The IAM role that allows the Logging & Monitoring account to list the other accounts in the organization
resource "aws_iam_role" "list_org_accounts" {
  count              = var.is_root_aws_account ? 1 : 0
  name               = "CloudWatch-CrossAccountSharing-ListAccountsRole"
  assume_role_policy = data.template_file.allow_assume_list_org_accounts.rendered
  path               = "/"
  description        = "IAM role that allows Logging & Monitoring account to list other accounts in the organization."

  tags = var.tags
}