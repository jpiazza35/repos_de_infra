output "sns_topic_arn" {
  value = aws_sns_topic.notification_topic.arn
}

output "lambda_arn" {
  value = aws_lambda_function.notification_lambda.arn
}
