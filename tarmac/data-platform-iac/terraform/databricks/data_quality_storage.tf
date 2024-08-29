module "data_quality_bucket" {
  source     = "../modules/storage_bucket"
  name       = "${module.workspace_vars.env}-data-quality-service"
  account_id = data.aws_caller_identity.current.account_id
}



data "aws_iam_policy_document" "dq_access" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [module.data_quality_bucket.bucket_arn]
  }

  statement {
    effect = "Allow"
    actions = ["s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    "s3:PutObjectAcl"]
    resources = [
      "${module.data_quality_bucket.bucket_arn}/*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = [
      module.data_quality_bucket.kms_key_arn
    ]
  }

  # combine with artifact storage policy
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetBucketLocation"]
    resources = [module.artifact_bucket.bucket_arn]
  }

  statement {
    effect = "Allow"
    actions = ["s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    "s3:PutObjectAcl"]
    resources = [
      "${module.artifact_bucket.bucket_arn}/*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      module.artifact_bucket.kms_key_arn
    ]
  }
}

module "dq_instance_profile" {
  source          = "../modules/instance_profile"
  env             = module.workspace_vars.env
  iam_policy_json = data.aws_iam_policy_document.dq_access.json
  name            = "data-quality-report-editor"
}


resource "databricks_group_role" "dq_editor_sdlc" {
  count    = module.workspace_vars.env == "sdlc" ? 1 : 0
  group_id = data.databricks_group.users.id
  role     = module.dq_instance_profile.instance_profile_name
}


resource "databricks_group_role" "data_engineer_dq_editor" {
  group_id = data.databricks_group.data_engineers.id
  role     = module.dq_instance_profile.instance_profile_name
}
