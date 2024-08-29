data "aws_caller_identity" "current" {}

# AWS IAM Managed Policies
data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy" "AdminAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "BillingAccess" {
  arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

data "aws_iam_policy" "IAMChangePassword" {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

# Terraform created IAM policies
data "template_file" "user_iam_self_mfa_document" {
  template = file("${path.module}/iam_policies/user_iam_self_mfa.json")
  vars = {
    current_account = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "list_org_accounts" {
  template = file("${path.module}/iam_policies/list_org_accounts.json")

  vars = {
    product_ou_arn = var.product_ou_arn
  }
}

data "template_file" "allow_assume_list_org_accounts" {
  template = file("${path.module}/iam_policies/allow_assume_list_org_accounts.json")

  vars = {
    logging_aws_account_id = var.logging_aws_account_id
  }
}