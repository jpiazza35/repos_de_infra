resource "aws_lambda_function" "machine_user_key_alert" {
  count            = var.create_lambda_resources ? 1 : 0
  function_name    = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-machine-user-key-alert"
  description      = "Lambda function to alert for machine user key expiration"
  handler          = "machine_user_key_alert.lambda_handler"
  filename         = data.archive_file.machine_user_key_alert[count.index].output_path
  source_code_hash = filebase64sha256(data.archive_file.machine_user_key_alert[count.index].output_path)
  role             = aws_iam_role.machine_user_key_alert[count.index].arn
  runtime          = var.lambdas_runtime
  timeout          = var.lambdas_timeout
  memory_size      = var.lambdas_memory_size

  environment {
    variables = {
      SNS_TOPIC_ARN = "${var.sns_topic_arn}"
      ACCOUNT_NAME  = "${var.account_name}"
      DAYS_OLD      = "${var.days_old_notify}"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.machine_user_key_alert
  ]

  tags = var.tags
}
