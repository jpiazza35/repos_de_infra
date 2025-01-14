### IAM configs ###

# The IAM role for the DynamoDB Lambda functions
resource "aws_iam_role" "dyndb_lambdas_role" {
  count              = var.create_lambda_resources ? 1 : 0
  name               = "${var.tags["Environment"]}-dynamodb-lambdas-role"
  assume_role_policy = var.assume_lambda_role_policy
  description        = "This role is used by the DynamoDB Lambda functions."

  tags = var.tags
}

# IAM policy allowing DynamoDB Lambdas IAM role access to AWS services
resource "aws_iam_policy" "dyndb_lambdas_policy" {
  count       = var.create_lambda_resources ? 1 : 0
  name        = "${var.tags["Environment"]}-dynamodb-lambdas-services-access"
  description = "This policy allows the DynamoDB Lambdas role access to AWS services."
  path        = "/"
  policy      = data.template_file.dyndb_lambdas_policy.rendered

  tags = var.tags
}

# Attach IAM policy for accessing AWS services
resource "aws_iam_role_policy_attachment" "dyndb_lambdas_policy" {
  count      = var.create_lambda_resources ? 1 : 0
  role       = aws_iam_role.dyndb_lambdas_role[count.index].name
  policy_arn = aws_iam_policy.dyndb_lambdas_policy[count.index].arn
}

# Add user Lambda #
resource "aws_cloudwatch_event_rule" "dyndb_add_user_lambda" {
  count         = var.create_lambda_resources ? 1 : 0
  name          = "DynamoDBAddUserLambda"
  description   = "Trigger the DynamoDB add-user Lambda function."
  event_pattern = <<PATTERN
{
  "source": [
    "aws.sso-directory"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
        "sso-directory.amazonaws.com"
    ],
    "eventName": [
        "CreateUser"
    ]
  }
}
PATTERN

  depends_on = [
    aws_lambda_function.dyndb_add_user,
  ]

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "dyndb_add_user_lambda" {
  count = var.create_lambda_resources ? 1 : 0
  arn   = aws_lambda_function.dyndb_add_user[count.index].arn
  rule  = aws_cloudwatch_event_rule.dyndb_add_user_lambda[count.index].name

  depends_on = [
    aws_lambda_function.dyndb_add_user,
  ]
}

resource "aws_lambda_permission" "dyndb_add_user_lambda" {
  count         = var.create_lambda_resources ? 1 : 0
  statement_id  = "AllowExecutionFromEventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dyndb_add_user[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.dyndb_add_user_lambda[count.index].arn

  depends_on = [
    aws_lambda_function.dyndb_add_user,
  ]
}

# Remove user Lambda #
resource "aws_cloudwatch_event_rule" "dyndb_remove_user_lambda" {
  count         = var.create_lambda_resources ? 1 : 0
  name          = "DynamoDBRemoveUserLambda"
  description   = "Trigger the DynamoDB remove-user Lambda function."
  event_pattern = <<PATTERN
{
  "source": [
    "aws.sso-directory"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
        "sso-directory.amazonaws.com"
    ],
    "eventName": [
        "DeleteUser"
    ]
  }
}
PATTERN

  depends_on = [
    aws_lambda_function.dyndb_remove_user,
  ]

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "dyndb_remove_user_lambda" {
  count = var.create_lambda_resources ? 1 : 0
  arn   = aws_lambda_function.dyndb_remove_user[count.index].arn
  rule  = aws_cloudwatch_event_rule.dyndb_remove_user_lambda[count.index].name

  depends_on = [
    aws_lambda_function.dyndb_remove_user,
  ]
}

resource "aws_lambda_permission" "dyndb_remove_user_lambda" {
  count         = var.create_lambda_resources ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dyndb_remove_user[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.dyndb_remove_user_lambda[count.index].arn

  depends_on = [
    aws_lambda_function.dyndb_remove_user,
  ]
}