# ### IAM configs ###

# # The IAM role for the SSO Lambda functions
# resource "aws_iam_role" "sso_lambdas_role" {
#   count              = var.create_lambda_resources ? 1 : 0
#   name               = "${var.tags["Environment"]}-sso-lambdas-role"
#   assume_role_policy = var.assume_lambda_role_policy
#   description        = "This role is used by the SSO Lambda functions."

#   tags = var.tags
# }

# # IAM policy allowing SSO Lambdas IAM role access to AWS services
# resource "aws_iam_policy" "sso_lambdas_policy" {
#   count       = var.create_lambda_resources ? 1 : 0
#   name        = "${var.tags["Environment"]}-sso-lambdas-services-access"
#   description = "This policy allows the SSO Lambdas role access to AWS services."
#   path        = "/"
#   policy = templatefile("${path.module}/iam_policies/sso_lambdas_policy.json", {
#     region                 = var.region,
#     aws_account_id         = data.aws_caller_identity.current.account_id,
#     dynamodb_table_name    = aws_dynamodb_table.sso_users.name,
#     sns_topic_arn          = var.sns_topic_arn
#     sns_topic_cmk_arn      = var.sns_topic_cmk_arn
#   })

#   tags = var.tags
# }

# # Attach IAM policy for accessing AWS services
# resource "aws_iam_role_policy_attachment" "sso_lambdas_policy" {
#   count      = var.create_lambda_resources ? 1 : 0
#   role       = aws_iam_role.sso_lambdas_role[count.index].name
#   policy_arn = aws_iam_policy.sso_lambdas_policy[count.index].arn
# }

# ### Eventbridge configs ###

# # User inactivity Lambda #
# resource "aws_cloudwatch_event_rule" "sso_lambda_inactivity" {
#   count               = var.create_lambda_resources ? 1 : 0
#   name                = "SSOLambdaUserInactivityEventRule"
#   description         = "Triggers the SSO user-inactivity Lambda function."
#   schedule_expression = var.lambda_cw_schedule_expression

#   depends_on = [
#     aws_lambda_function.user_inactivity,
#   ]

#   tags = var.tags
# }

# resource "aws_cloudwatch_event_target" "sso_lambda_inactivity" {
#   count = var.create_lambda_resources ? 1 : 0
#   arn   = aws_lambda_function.user_inactivity[count.index].arn
#   rule  = aws_cloudwatch_event_rule.sso_lambda_inactivity[count.index].name

#   depends_on = [
#     aws_lambda_function.user_inactivity,
#   ]
# }

# resource "aws_lambda_permission" "invoke_user_inactivity_lambda" {
#   count         = var.create_lambda_resources ? 1 : 0
#   statement_id  = "AllowExecutionFromEventbridge"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.user_inactivity[count.index].function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.sso_lambda_inactivity[count.index].arn

#   depends_on = [
#     aws_lambda_function.user_inactivity,
#   ]
# }

# # Password expiration Lambda #
# resource "aws_cloudwatch_event_rule" "sso_lambda_password_expiration" {
#   count               = var.create_lambda_resources ? 1 : 0
#   name                = "SSOLambdaPasswordExpirationEventRule"
#   description         = "Trigger the SSO password-expiration Lambda function."
#   schedule_expression = var.lambda_cw_schedule_expression

#   depends_on = [
#     aws_lambda_function.password_expiration,
#   ]

#   tags = var.tags
# }

# resource "aws_cloudwatch_event_target" "sso_lambda_password_expiration" {
#   count = var.create_lambda_resources ? 1 : 0
#   arn   = aws_lambda_function.password_expiration[count.index].arn
#   rule  = aws_cloudwatch_event_rule.sso_lambda_password_expiration[count.index].name

#   depends_on = [
#     aws_lambda_function.password_expiration,
#   ]
# }

# resource "aws_lambda_permission" "invoke_password_expiration_lambda" {
#   count         = var.create_lambda_resources ? 1 : 0
#   statement_id  = "AllowExecutionFromEventbridge"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.password_expiration[count.index].function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.sso_lambda_password_expiration[count.index].arn

#   depends_on = [
#     aws_lambda_function.password_expiration,
#   ]
# }
