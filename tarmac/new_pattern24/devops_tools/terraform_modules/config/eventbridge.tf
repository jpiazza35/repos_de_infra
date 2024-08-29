resource "aws_cloudwatch_event_rule" "config_compliance_lambda" {
  count         = var.create_lambda_resources ? 1 : 0
  name          = "Config-Rules-Compliance-Status-Change"
  description   = "Trigger the Config rules compliance status Lambda function."
  event_pattern = <<PATTERN
{
  "source": [
      "aws.config"
    ],
  "detail-type": [
      "Config Rules Compliance Change"
    ],
  "detail": {
    "messageType": [
        "ComplianceChangeNotification"
    ]
  }
}
PATTERN

  depends_on = [
    aws_lambda_function.config_compliance_lambda,
  ]

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "config_compliance_lambda" {
  count = var.create_lambda_resources ? 1 : 0
  arn   = aws_lambda_function.config_compliance_lambda[count.index].arn
  rule  = aws_cloudwatch_event_rule.config_compliance_lambda[count.index].name

  depends_on = [
    aws_lambda_function.config_compliance_lambda,
  ]
}

resource "aws_lambda_permission" "config_compliance_lambda" {
  count         = var.create_lambda_resources ? 1 : 0
  statement_id  = "AllowExecutionFromEventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.config_compliance_lambda[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.config_compliance_lambda[count.index].arn

  depends_on = [
    aws_lambda_function.config_compliance_lambda,
  ]
}