# data "archive_file" "user_inactivity" {
#   count       = var.create_lambda_resources ? 1 : 0
#   type        = "zip"
#   output_path = "sso_user_inactivity.zip"
#   source_file = "${path.module}/lambdas/sso_user_inactivity.py"
# }

# resource "aws_lambda_function" "user_inactivity" {
#   count            = var.create_lambda_resources ? 1 : 0
#   function_name    = "${var.tags["Environment"]}-sso-user-inactivity"
#   description      = "This function is used to fetch the last time an SSO user has logged on to SSO portal."
#   handler          = "sso_user_inactivity.lambda_handler"
#   filename         = data.archive_file.user_inactivity[count.index].output_path
#   source_code_hash = filebase64sha256(data.archive_file.user_inactivity[count.index].output_path)
#   role             = aws_iam_role.sso_lambdas_role[count.index].arn
#   runtime          = var.lambdas_runtime
#   timeout          = var.lambdas_timeout
#   memory_size      = var.lambdas_memory_size

#   environment {
#     variables = {
#       DYNAMODB_TABLE = aws_dynamodb_table.sso_users.name
#       SNS_TOPIC_ARN  = var.sns_topic_arn
#     }
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.sso_lambdas_policy,
#   ]

#   tags = var.tags
# }
