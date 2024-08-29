module "organizations" {
  source = "../modules/organizations"

  # Organization Policies
  DsKlqh = data.template_file.DsKlqh.rendered
  fsPKWB = data.template_file.fsPKWB.rendered
  HHmslj = data.template_file.HHmslj.rendered
  hrVqLt = data.template_file.hrVqLt.rendered
  yBOtDK = data.template_file.yBOtDK.rendered

}

module "sso" {
  source = "../modules/sso"

  create_lambda_resources       = true
  cw_retention_in_days          = 180
  lambda_cw_schedule_expression = "rate(1 day)"

  region = var.region

  logging_aws_account_id         = "531588107891"
  security_aws_account_id        = "168621007529"
  shared_services_aws_account_id = "044888517122"
  networking_aws_account_id      = "089708604169"
  infra_code_aws_account_id      = "467243286668"
  proxy_dev_aws_account_id       = "724899048942"
  proxy_test_aws_account_id      = "835561590741"
  proxy_prod_aws_account_id      = "392203476474"

  lambdas_runtime     = "python3.8"
  lambdas_timeout     = 60
  lambdas_memory_size = 128

  dyndb_table_name     = "SSOUsersList"
  dyndb_read_capacity  = 5
  dyndb_write_capacity = 5
  dyndb_hash_key       = "UserId"
  dyndb_range_key      = "Username"

  logging_account_sqs_queue_url = "https://sqs.${var.region}.amazonaws.com/${var.logging_aws_account_id}/core-alerts-queue"

  assume_lambda_role_policy = data.template_file.assume_lambda_role_policy.rendered

  # The following data source(s) is/are managed and created within the KMS module
  cw_log_groups_kms_key_arn = element(module.kms.cw_log_groups_kms_key_arn, 0)

  tags = merge(
    var.tags,
    {
      "AWSService" = "SSO"
    },
  )
}

module "iam" {
  source = "../modules/iam"

  is_root_aws_account = true

  region                         = ""
  sso_instance                   = module.sso.sso_instance
  logging_aws_account_id         = "531588107891"
  shared_services_aws_account_id = "044888517122"
  product_ou_arn                 = "arn:aws:organizations::${data.aws_caller_identity.current.account_id}:ou/${module.organizations.org_id}/${module.organizations.product_ou_id}"

  iam_minimum_password_length               = 8
  iam_password_require_lowercase_characters = true
  iam_password_require_uppercase_characters = true
  iam_password_require_numbers              = true
  iam_password_require_symbols              = true
  iam_allow_users_to_change_password        = true
  iam_password_reuse_prevention             = 5
  iam_max_password_age                      = 90

  tags = merge(
    var.tags,
    {
      "AWSService" = "IAM"
    },
  )
}

module "kms" {
  source = "../modules/kms"
  region = var.region

  is_productou             = false
  enable_key_rotation      = true
  create_ecr_key           = false
  create_sqs_key           = false
  create_cw_log_groups_key = true
  create_cloudtrail_key    = false

  code_pipeline_role_arn     = ""
  sql_automation_lambda_role = ""

  tags = var.tags
}