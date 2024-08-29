output "sns_topic_arn" {
  value = aws_sns_topic.sns_topic.arn
}

output "subscription_list" {
  value = {
    for k, v in aws_sns_topic_subscription.email_subscription : k => v.endpoint
  }
}
