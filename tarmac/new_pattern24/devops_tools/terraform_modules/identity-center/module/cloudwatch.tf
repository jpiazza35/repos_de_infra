# resource "aws_cloudwatch_log_group" "user_inactivity" {
#   count             = var.create_lambda_resources ? 1 : 0
#   name              = "/aws/lambda/${var.tags["Environment"]}-sso-user-inactivity"
#   kms_key_id        = var.cw_log_groups_kms_key_arn
#   retention_in_days = var.cw_retention_in_days

#   tags = var.tags
# }

# resource "aws_cloudwatch_log_group" "password_expiration" {
#   count             = var.create_lambda_resources ? 1 : 0
#   name              = "/aws/lambda/${var.tags["Environment"]}-sso-password-expiration"
#   kms_key_id        = var.cw_log_groups_kms_key_arn
#   retention_in_days = var.cw_retention_in_days

#   tags = var.tags
# }

resource "aws_cloudwatch_log_group" "dyndb_add_user" {
  count = var.create_lambda_resources ? 1 : 0
  name  = "/aws/lambda/${var.tags["Environment"]}-sso-dynamodb-add-user"
  #kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "dyndb_remove_user" {
  count = var.create_lambda_resources ? 1 : 0
  name  = "/aws/lambda/${var.tags["Environment"]}-sso-dynamodb-remove-user"
  #kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

# resource "aws_cloudwatch_log_group" "iam_failed_login" {
#   count             = var.create_lambda_resources ? 1 : 0
#   name              = "/aws/lambda/${aws_lambda_function.iam_failed_login[count.index].function_name}"
#   kms_key_id        = var.cw_log_groups_kms_key_arn
#   retention_in_days = var.cw_retention_in_days

#   tags = var.tags
# }

# resource "aws_cloudwatch_log_group" "sso_failed_cloud_trail_logs" {
#   count             = var.sso_failed_login_cloudtrail ? 1 : 0
#   name              = "/aws/cloudtrail/${var.tags["Environment"]}-sso-failed-login"
#   kms_key_id        = var.cw_log_groups_kms_key_arn
#   retention_in_days = var.cw_retention_in_days

#   tags = var.tags
# }

# resource "aws_cloudwatch_log_subscription_filter" "sso_failed_login_filter" {
#   count = var.sso_failed_login_cloudtrail ? 1 : 0

#   name            = "${var.tags["Environment"]}-sso-failed-login-filter"
#   log_group_name  = element(concat(aws_cloudwatch_log_group.sso_failed_cloud_trail_logs.*.name, tolist([""])), 0)
#   filter_pattern  = "{ $.serviceEventDetails.CredentialVerification = \"Failure\" }"
#   destination_arn = element(concat(aws_lambda_function.sso_failed_login.*.arn, tolist([""])), 0)
#   distribution    = "Random"

# }

# resource "aws_cloudwatch_log_group" "sso_failed_login_lambda" {
#   count             = var.sso_failed_login_cloudtrail ? 1 : 0
#   name              = "/aws/lambda/${element(concat(aws_lambda_function.sso_failed_login.*.function_name, tolist([""])), 0)}"
#   kms_key_id        = var.cw_log_groups_kms_key_arn
#   retention_in_days = var.cw_retention_in_days

#   tags = var.tags
# }
