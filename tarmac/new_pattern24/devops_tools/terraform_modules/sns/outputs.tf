output "sns_arn" {
  description = "The arn of the SNS notification."
  value       = aws_sns_topic.sns_notifications.*.arn
}

output "sns_arn_codecommit" {
  description = "The arn of the codecommit SNS topic."
  value       = aws_sns_topic.sns_codecommit.*.arn
}