data "archive_file" "dyndb_add_user" {
  count       = var.create_lambda_resources ? 1 : 0
  type        = "zip"
  output_path = "dyndb_add_user.zip"
  source_file = "${path.module}/lambdas/dyndb_add_user.py"
}

resource "aws_lambda_function" "dyndb_add_user" {
  count            = var.create_lambda_resources ? 1 : 0
  function_name    = "${var.tags["Environment"]}-dynamodb-add-user"
  description      = "This function is used to update the SSOUsersList DynamoDB table when a new SSO user is created."
  handler          = "dyndb_add_user.lambda_handler"
  filename         = data.archive_file.dyndb_add_user[count.index].output_path
  source_code_hash = filebase64sha256(data.archive_file.dyndb_add_user[count.index].output_path)
  role             = aws_iam_role.dyndb_lambdas_role[count.index].arn
  runtime          = var.lambdas_runtime
  timeout          = var.lambdas_timeout
  memory_size      = var.lambdas_memory_size

  environment {
    variables = {
      DYNAMODB_TABLE       = aws_dynamodb_table.sso_users.name
      SSO_IDENTITYSTORE_ID = tolist(data.aws_ssoadmin_instances.example-account.identity_store_ids)[0]
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.dyndb_lambdas_policy,
    aws_cloudwatch_log_group.dyndb_add_user,
  ]

  tags = var.tags
}
