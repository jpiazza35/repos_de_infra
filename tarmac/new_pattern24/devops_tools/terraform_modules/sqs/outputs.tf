output "sqs_queue_arn" {
  description = "The arn of the SQS queue."
  value       = aws_sqs_queue.sqs.*.arn
}