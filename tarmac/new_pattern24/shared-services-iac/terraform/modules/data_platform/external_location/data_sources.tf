data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        "ad35a21f-129b-4626-884f-7ee496730a60"
      ]
    }
  }
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    sid     = "AssumeSelf"
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.databricks_workspace_name}-${var.prefix}-external-access"
    ]
  }
}

data "databricks_user" "user" {
  user_name = var.dsci_admin
}

data "databricks_group" "external_storage_admins" {
  for_each     = toset(var.external_storage_admins_display_name)
  display_name = each.value
}

data "databricks_aws_assume_role_policy" "assume_policy" {
  external_id = "ad35a21f-129b-4626-884f-7ee496730a60"
}

data "databricks_aws_crossaccount_policy" "cross_acct_policy" {}

data "aws_s3_bucket" "external" {
  bucket = var.s3_bucket_name
}
