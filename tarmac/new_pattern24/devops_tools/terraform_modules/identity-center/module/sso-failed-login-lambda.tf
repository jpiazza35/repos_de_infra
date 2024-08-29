# data "archive_file" "sso_failed_login" {
#   count       = var.create_lambda_resources ? 1 : 0
#   type        = "zip"
#   output_path = "sso_failed_login.zip"
#   source_file = "${path.module}/lambdas/sso_failed_login.py"
# }

# resource "aws_lambda_function" "sso_failed_login" {
#   count            = var.create_lambda_resources ? 1 : 0
#   function_name    = "${var.tags["Environment"]}-sso-failed-login"
#   description      = "This function sends an alert when an SSO user has >= 6 failed logins"
#   handler          = "sso_failed_login.lambda_handler"
#   filename         = data.archive_file.sso_failed_login[count.index].output_path
#   source_code_hash = filebase64sha256(data.archive_file.sso_failed_login[count.index].output_path)
#   role             = aws_iam_role.sso_failed_login[count.index].arn
#   runtime          = var.lambdas_runtime
#   timeout          = var.lambdas_timeout
#   memory_size      = var.lambdas_memory_size

#   environment {
#     variables = {
#       SNS_TOPIC_ARN  = var.sns_topic_arn
#       DYNAMODB_TABLE = var.dyndb_sso_failed_table_name
#     }
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.sso_lambdas_policy,
#   ]

#   tags = var.tags
# }
