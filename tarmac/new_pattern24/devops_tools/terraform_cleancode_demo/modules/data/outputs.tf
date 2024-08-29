output "dynamodb_table" {
  description = "Dynamo db table"
  value       = aws_dynamodb_table.this.arn
}