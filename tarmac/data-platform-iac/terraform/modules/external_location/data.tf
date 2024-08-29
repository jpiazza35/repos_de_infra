data "aws_s3_bucket" "bucket" {
  count  = var.create_bucket ? 0 : 1
  bucket = var.s3_bucket
}

data "aws_iam_role" "role" {
  name = var.storage_credential_iam_role
}

data "databricks_current_user" "current_user" {}
