output "lambda_arn" {
  value       = aws_lambda_function.lambda_function.arn
  description = "value of the lambda arn"
}

output "role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "value of the lambda role arn"
}

output "lambda_role_id" {
  value       = aws_iam_role.lambda_role.id
  description = "value of the lambda role id"
}
