# resource "aws_iam_role" "iam_failed_login_eventbridge" {
#   name               = "${var.tags["Environment"]}-iam-failed-login-eventbridge-role"
#   assume_role_policy = var.assume_events_role_policy
#   description        = "This role is used by the IAMUserLoginFailed Eventbridge rule in us-east-1."

#   tags = var.tags
# }

# resource "aws_iam_policy" "iam_failed_login_eventbridge" {
#   name = "${var.tags["Environment"]}-iam-failed-login-eventbridge-policy"
#   policy = templatefile("${path.module}/iam_policies/eventbridge_allow_eventbus_policy.json", {
#     region         = var.region,
#     aws_account_id = data.aws_caller_identity.current.account_id
#   })
#   description = "This policy allows the IAMUserLoginFailed Eventbridge rule in us-east-1 access to Frankfurt event bus."
# }

# resource "aws_iam_role_policy_attachment" "iam_failed_login_eventbridge" {
#   role       = aws_iam_role.iam_failed_login_eventbridge.name
#   policy_arn = aws_iam_policy.iam_failed_login_eventbridge.arn
# }

# resource "aws_lambda_permission" "iam_failed_login" {
#   count         = var.create_lambda_resources ? 1 : 0
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.iam_failed_login[count.index].function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.iam_failed_login[count.index].arn

#   depends_on = [
#     aws_lambda_function.iam_failed_login,
#   ]
# }

# resource "aws_cloudwatch_event_rule" "iam_failed_login" {
#   count         = var.create_lambda_resources ? 1 : 0
#   name          = "IAMUserLoginFailedEU"
#   description   = "Trigger a Lambda function after IAM user failed login."
#   event_pattern = <<PATTERN
# {
#     "detail-type": [
#         "AWS Console Sign In via CloudTrail"
#     ],
#     "detail": {
#         "responseElements": {
#             "ConsoleLogin": [
#                 "Failure"
#             ]
#         }
#     }
# }
# PATTERN

#   depends_on = [
#     aws_lambda_function.iam_failed_login,
#   ]

#   tags = var.tags
# }

# resource "aws_cloudwatch_event_target" "iam_failed_login" {
#   count = var.create_lambda_resources ? 1 : 0
#   arn   = aws_lambda_function.iam_failed_login[count.index].arn
#   rule  = aws_cloudwatch_event_rule.iam_failed_login[count.index].name

#   depends_on = [
#     aws_lambda_function.iam_failed_login,
#   ]
# }

# ## N. Virginia (us-east-1) Eventbridge resources

# resource "aws_cloudwatch_event_rule" "iam_failed_login_us_east" {
#   provider      = aws.us-east-1
#   count         = var.create_lambda_resources ? 1 : 0
#   name          = "IAMUserLoginFailed"
#   description   = "Trigger a Lambda function after IAM user failed login."
#   event_pattern = <<PATTERN
# {
#     "detail-type": [
#         "AWS Console Sign In via CloudTrail"
#     ],
#     "detail": {
#         "responseElements": {
#             "ConsoleLogin": [
#                 "Failure"
#             ]
#         }
#     }
# }
# PATTERN

#   depends_on = [
#     aws_lambda_function.iam_failed_login,
#   ]

#   tags = var.tags
# }

# resource "aws_cloudwatch_event_target" "iam_failed_login_us_east" {
#   provider = aws.us-east-1
#   count    = var.create_lambda_resources ? 1 : 0
#   arn      = "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:event-bus/default"
#   rule     = aws_cloudwatch_event_rule.iam_failed_login_us_east[count.index].name
#   role_arn = aws_iam_role.iam_failed_login_eventbridge.arn

#   depends_on = [
#     aws_lambda_function.iam_failed_login,
#   ]
# }

# # The IAM role for iam_failed_login Lambda function
# resource "aws_iam_role" "iam_failed_login" {
#   count              = var.create_lambda_resources ? 1 : 0
#   name               = "${var.tags["Environment"]}-iam-failed-login-lambda-role"
#   assume_role_policy = var.assume_lambda_role_policy
#   description        = "This role is used by iam_failed_login Lambda function."

#   tags = var.tags
# }

# # IAM policy allowing iam_failed_login Lambda IAM role access to AWS services
# resource "aws_iam_policy" "lambdas_policy_iam_failed_login" {
#   count       = var.create_lambda_resources ? 1 : 0
#   name        = "${var.tags["Environment"]}-iam-failed-login-lambda-services-access"
#   description = "This policy allows the iam_failed_login Lambda role access to AWS services."
#   path        = "/"
#   policy = templatefile("${path.module}/iam_policies/lambdas_policy_iam_failed_login.json", {
#     region             = var.region,
#     aws_account_id     = data.aws_caller_identity.current.account_id,
#     dynamodb_table_arn = aws_dynamodb_table.iam_failed_login.arn,
#     sns_topic_arn      = var.sns_topic_arn
#     sns_topic_cmk_arn  = var.sns_topic_cmk_arn
#   })

#   tags = var.tags
# }

# # Attach IAM policy for accessing AWS services
# resource "aws_iam_role_policy_attachment" "iam_failed_login" {
#   count      = var.create_lambda_resources ? 1 : 0
#   role       = aws_iam_role.iam_failed_login[count.index].name
#   policy_arn = aws_iam_policy.lambdas_policy_iam_failed_login[count.index].arn
# }