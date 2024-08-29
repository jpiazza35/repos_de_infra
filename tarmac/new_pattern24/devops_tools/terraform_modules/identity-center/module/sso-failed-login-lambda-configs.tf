# resource "aws_lambda_permission" "sso_failed_login" {
#   count         = var.create_lambda_resources ? 1 : 0
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.sso_failed_login[count.index].function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_log_group.sso_failed_cloud_trail_logs[count.index].arn

#   depends_on = [
#     aws_lambda_function.sso_failed_login,
#   ]
# }

# # The SSO role for sso_failed_login Lambda function
# resource "aws_iam_role" "sso_failed_login" {
#   count              = var.create_lambda_resources ? 1 : 0
#   name               = "${var.tags["Environment"]}-sso-failed-login-role"
#   assume_role_policy = var.assume_lambda_role_policy
#   description        = "This role is used by sso_failed_login Lambda function."

#   tags = var.tags
# }

# # SSO policy allowing sso_failed_login Lambda SSO role access to AWS services
# resource "aws_iam_policy" "lambdas_policy_sso_failed_login" {
#   count       = var.create_lambda_resources ? 1 : 0
#   name        = "${var.tags["Environment"]}-sso-failed-login-services-access"
#   description = "This policy allows the sso_failed_login Lambda role access to AWS services."
#   path        = "/"
#   policy = templatefile("${path.module}/iam_policies/lambdas_policy_sso_failed_login.json", {
#     region             = var.region,
#     aws_account_id     = data.aws_caller_identity.current.account_id,
#     dynamodb_table_arn = aws_dynamodb_table.sso_failed_login.arn,
#     sns_topic_arn      = var.sns_topic_arn
#     sns_topic_cmk_arn  = var.sns_topic_cmk_arn
#   })

#   tags = var.tags
# }

# # Attach SSO policy for accessing AWS services
# resource "aws_iam_role_policy_attachment" "sso_failed_login" {
#   count      = var.create_lambda_resources ? 1 : 0
#   role       = aws_iam_role.sso_failed_login[count.index].name
#   policy_arn = aws_iam_policy.lambdas_policy_sso_failed_login[count.index].arn
# }