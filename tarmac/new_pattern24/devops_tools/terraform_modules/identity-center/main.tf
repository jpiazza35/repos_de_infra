module "ic" {
  source = "./module"

  create_lambda_resources       = true
  sso_failed_login_cloudtrail   = false
  cw_retention_in_days          = 180
  lambda_cw_schedule_expression = "rate(1 day)"

  region  = var.region
  profile = var.profile

  account_assignments = local.account_assignments
  sso_users           = local.sso_users

  permission_sets = {
    AdminPermissionSet = {
      description      = "Provides full access to all AWS services.",
      session_duration = "PT8H",
      managed_policy   = data.aws_iam_policy.admin.arn
    },
    ReadOnlyPermissionSet = {
      description      = "View resources and basic metadata across all AWS services.",
      session_duration = "PT2H",
      managed_policy   = data.aws_iam_policy.readonly.arn
    },
    BillingPermissionSet = {
      description      = "View billing resources across all AWS services.",
      session_duration = "PT2H",
      managed_policy   = data.aws_iam_policy.billing.arn
    }
  }

  lambdas_runtime     = "python3.11"
  lambdas_timeout     = 60
  lambdas_memory_size = 128

  dyndb_table_name               = "SSOUsersList"
  dyndb_read_capacity            = 5
  dyndb_write_capacity           = 5
  dyndb_sso_users_list_hash_key  = "UserId"
  dyndb_sso_users_list_range_key = "Username"
  dyndb_iam_failed_table_name    = "IAMfailedLogins"
  dyndb_sso_failed_table_name    = "SSOfailedLogins"
  dyndb_failed_logins_hash_key   = "DateTime"
  dyndb_failed_logins_range_key  = "Username"

  assume_lambda_role_policy = templatefile("${path.module}/iam_policies/assume_lambda_role_policy.json", {})
  assume_events_role_policy = templatefile("${path.module}/iam_policies/assume_events_role_policy.json", {})
  sns_topic_arn             = ""
  sns_topic_cmk_arn         = ""

  # The following variables values should be added after KMS is applied/configured
  cw_log_groups_kms_key_arn = ""
  s3_kms_key_alias          = ""
  cloudtrail_kms_key_arn    = ""

  tags = merge(
    var.tags,
    {
      "AWSService" = "IAM Identity Center"
    },
  )
}