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

data "aws_iam_policy" "aws_artifact" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSArtifactAccountSync"
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

data "template_file" "doc_vault" {
  template = file("${path.module}/iam_policies/example_machine_user.json")
  vars = {
    document_vault_s3_bucket = var.document_vault_s3_bucket
    region                   = var.region
    aws_account_id           = data.aws_caller_identity.current.account_id
    s3_kms_key_id            = "my-s3-kms-key"
  }
}

# Gives Lambda roles access to services
data "template_file" "machine_user_key_alert_policy" {
  template = file("${path.module}/iam_policies/machine_user_key_alert_policy.json")

  vars = {
    sns_topic_arn = var.sns_topic_arn
  }
}

data "archive_file" "machine_user_key_alert" {
  count       = var.create_lambda_resources ? 1 : 0
  type        = "zip"
  output_path = "machine_user_key_alert.zip"
  source_dir  = "${path.module}/lambdas/"
}
