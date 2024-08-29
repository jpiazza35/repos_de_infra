resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  policy_arn = aws_iam_policy.s3_access.arn
  role       = var.storage_credential_iam_role
}


resource "aws_iam_policy" "s3_access" {
  description = "Policy for Databricks to access ${var.name} bucket."
  policy      = data.aws_iam_policy_document.s3_access_document.json
}

module "bucket" {
  count      = var.create_bucket ? 1 : 0
  source     = "../storage_bucket"
  name       = "external-location-${var.name}"
  account_id = var.account_id
}

locals {
  s3_bucket_arn = var.create_bucket ? module.bucket[0].bucket_arn : "arn:aws:s3:::${var.s3_bucket}"
  s3_bucket     = var.create_bucket ? module.bucket[0].bucket_name : var.s3_bucket
  s3_url        = "s3://${local.s3_bucket}/"

  kms_arn = var.create_bucket ? module.bucket[0].kms_key_arn : var.kms_arn
}

data "aws_iam_policy_document" "s3_access_document" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration"
    ]
    effect = "Allow"
    resources = [
      local.s3_bucket_arn,
      "${local.s3_bucket_arn}/*"
    ]
  }

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    resources = [
      data.aws_iam_role.role.arn
    ]
  }

  dynamic "statement" {
    for_each = local.kms_arn != null ? [1] : []
    content {
      actions = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey*"
      ]
      effect = "Allow"
      resources = [
        local.kms_arn
      ]
    }
  }
}

resource "aws_s3_object" "access_test" {
  count   = var.create_bucket ? 1 : 0
  bucket  = local.s3_bucket
  key     = "access_test.txt"
  content = "The purpose of this file is to validate that the external location has access to the bucket."
}


resource "time_sleep" "policy_propagation" {
  depends_on       = [aws_iam_role_policy_attachment.s3_access_attachment, aws_iam_policy.s3_access]
  create_duration  = "30s"
  destroy_duration = "30s"
}

resource "databricks_external_location" "this" {
  depends_on      = [aws_s3_object.access_test, time_sleep.policy_propagation]
  name            = var.name
  url             = local.s3_url
  credential_name = var.storage_credential_name
  comment         = var.comment
  skip_validation = false

}


resource "databricks_grants" "read_write_grants" {
  count             = var.permission_mode == "READ_WRITE" ? 1 : 0
  external_location = databricks_external_location.this.name

  grant {
    principal  = data.databricks_current_user.current_user.user_name
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = "${var.role_prefix}_admin"
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = "${var.role_prefix}_engineer"
    privileges = ["CREATE_EXTERNAL_TABLE", "CREATE_MANAGED_STORAGE", "READ_FILES"]
  }

  grant {
    principal  = "${var.role_prefix}_scientist"
    privileges = ["CREATE_EXTERNAL_TABLE", "CREATE_MANAGED_STORAGE", "READ_FILES"]
  }

  grant {
    principal  = "${var.role_prefix}_user"
    privileges = ["READ_FILES"]
  }

  dynamic "grant" {
    for_each = var.extra_grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
  #  grant {
  #    principal  = "${var.role_prefix}_mpt_developers"
  #    privileges = ["READ_FILES"]
  #  }
}

resource "databricks_grants" "read_only" {
  count             = var.permission_mode == "READ_ONLY" ? 1 : 0
  external_location = databricks_external_location.this.name

  grant {
    principal  = "${var.role_prefix}_admin"
    privileges = ["READ_FILES"]
  }

  grant {
    principal  = "${var.role_prefix}_engineer"
    privileges = ["READ_FILES"]
  }
}
