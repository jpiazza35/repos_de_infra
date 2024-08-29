resource "aws_sns_topic" "notification_topic" {
  name = local.sns_topic_name
}

resource "aws_sns_topic_subscription" "notification_subscription" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.notification_lambda.arn
}

resource "aws_lambda_permission" "notification_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notification_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification_topic.arn
}
