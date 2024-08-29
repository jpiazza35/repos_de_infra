module "survey_template_extracts_bucket" {
  source     = "../modules/storage_bucket"
  name       = "${module.workspace_vars.env}-survey-template-extracts"
  account_id = data.aws_caller_identity.current.account_id
}


# publisher - uploads files to s3 bucket
data "aws_iam_policy_document" "publisher_policy" {
  statement {
    sid = "S3Publish"
    actions = [
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      "${module.survey_template_extracts_bucket.bucket_arn}/*",
      module.survey_template_extracts_bucket.bucket_arn
    ]
  }

  statement {
    sid = "KMSAccess"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
    ]
    resources = [
      module.survey_template_extracts_bucket.kms_key_arn
    ]
  }

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
      "s3:GetObject",
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
  statement {
    effect  = "Allow"
    sid     = "CallFileAPI"
    actions = ["sts:AssumeRole"]
    resources = [
      var.file_api_role_arn
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${var.data_platform_account_id}:role/databricks_msk_assume_role"
    ]
  }
}

module "survey_template_instance_profile" {
  source          = "../modules/instance_profile"
  env             = module.workspace_vars.env
  iam_policy_json = data.aws_iam_policy_document.publisher_policy.json
  name            = "survey-template-publisher"
}
