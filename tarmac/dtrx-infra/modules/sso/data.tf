data "aws_caller_identity" "current" {
}

data "aws_ssoadmin_instances" "dtcloud" {
}

# AWS IAM Managed Policies
data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy" "AdminAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Gives SSO Lambda roles access to services
data "template_file" "sso_lambdas_policy" {
  template = file("${path.module}/iam_policies/sso_lambdas_policy.json")

  vars = {
    region                 = var.region
    logging_aws_account_id = var.logging_aws_account_id
    aws_account_id         = data.aws_caller_identity.current.account_id
    dynamodb_table_name    = aws_dynamodb_table.sso_users.name
  }
}

# Gives DynamoDB Lambda roles access to services
data "template_file" "dyndb_lambdas_policy" {
  template = file("${path.module}/iam_policies/dyndb_lambdas_policy.json")

  vars = {
    region              = var.region
    aws_account_id      = data.aws_caller_identity.current.account_id
    dynamodb_table_name = aws_dynamodb_table.sso_users.name
  }
}
