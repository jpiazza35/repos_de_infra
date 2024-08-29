data "aws_iam_role" "role" {
  name = var.storage_credential_iam_role
}

data "databricks_current_user" "current_user" {}
