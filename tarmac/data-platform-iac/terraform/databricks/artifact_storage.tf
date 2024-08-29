module "artifact_bucket" {
  source     = "../modules/storage_bucket"
  name       = "${module.workspace_vars.env}-artifacts"
  account_id = data.aws_caller_identity.current.account_id
}



data "aws_iam_policy_document" "s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [module.artifact_bucket.bucket_arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
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

module "instance_profile" {
  source          = "../modules/instance_profile"
  env             = module.workspace_vars.env
  iam_policy_json = data.aws_iam_policy_document.s3_access.json
  name            = "artifact-storage"
}


# grant to all users
data "databricks_group" "users" {
  display_name = "users"
}

resource "databricks_group_role" "users" {
  group_id = data.databricks_group.users.id
  role     = module.instance_profile.instance_profile_name
}
