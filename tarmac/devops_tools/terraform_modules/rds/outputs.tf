output "rds_security_group_id" {
  value       = aws_security_group.postgresql.id
  description = "The ID of the RDS postgresql security group."
}

output "rds_instance_endpoint" {
  value       = aws_db_instance.postgresql.endpoint
  description = "The endpoint (address and port) of the RDS database instance."
}

output "rds_instance_address" {
  value       = aws_db_instance.postgresql.address
  description = "The endpoint (address) of the RDS database instance."
}

output "rds_resource_id" {
  value       = aws_db_instance.postgresql.resource_id
  description = "The Resource ID of the RDS database."
}

output "sql_automation_lambda_role" {
  value       = aws_iam_role.sql_automation.arn
  description = "The SQL automation Lambda IAM role."
}