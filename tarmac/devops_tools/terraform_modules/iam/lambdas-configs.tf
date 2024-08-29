### Cloudwatch Log group ###

resource "aws_cloudwatch_log_group" "machine_user_key_alert" {
  count             = var.create_lambda_resources ? 1 : 0
  name              = "/aws/lambda/${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-machine-user-key-alert"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

### IAM configs ###

# The IAM role for the Lambda functions
resource "aws_iam_role" "machine_user_key_alert" {
  count              = var.create_lambda_resources ? 1 : 0
  name               = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-machine-user-key-alert"
  assume_role_policy = var.assume_lambda_role_policy
  description        = "IAM Role for the machine_user_key_alert lambda function to alert for machine user key expiration"

  tags = var.tags
}

# IAM policy allowing Lambdas IAM role access to AWS services
resource "aws_iam_policy" "machine_user_key_alert" {
  count       = var.create_lambda_resources ? 1 : 0
  name        = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-machine-user-key-alert"
  description = "This policy allows the Lambdas role access to AWS services."
  path        = "/"
  policy      = data.template_file.machine_user_key_alert_policy.rendered

  tags = var.tags
}

# Attach IAM policy for accessing AWS services
resource "aws_iam_role_policy_attachment" "machine_user_key_alert" {
  count      = var.create_lambda_resources ? 1 : 0
  role       = aws_iam_role.machine_user_key_alert[count.index].name
  policy_arn = aws_iam_policy.machine_user_key_alert[count.index].arn
}

### Eventbridge configs ###

# Lambda function to alert for machine user key expiration #
resource "aws_cloudwatch_event_rule" "machine_user_key_alert" {
  count               = var.create_lambda_resources ? 1 : 0
  name                = "LambdaMachineUserKeyExpirationAlert"
  description         = "Lambda function to alert for machine user key expiration"
  schedule_expression = var.lambda_cw_schedule_expression

  depends_on = [
    aws_lambda_function.machine_user_key_alert,
  ]

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "machine_user_key_alert" {
  count = var.create_lambda_resources ? 1 : 0
  arn   = aws_lambda_function.machine_user_key_alert[count.index].arn
  rule  = aws_cloudwatch_event_rule.machine_user_key_alert[count.index].name

  depends_on = [
    aws_lambda_function.machine_user_key_alert,
  ]
}

resource "aws_lambda_permission" "machine_user_key_alert" {
  count         = var.create_lambda_resources ? 1 : 0
  statement_id  = "AllowExecutionFromEventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.machine_user_key_alert[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.machine_user_key_alert[count.index].arn

  depends_on = [
    aws_lambda_function.machine_user_key_alert,
  ]
}
