output "endpoint" {
  value = aws_db_instance.rds[0].endpoint
}

output "password" {
  value = random_password.password[0].result
}

output "username" {
  value = var.user_name
}

output "db_name" {
  value = var.db_name
}

output "port" {
  value = aws_db_instance.rds[0].port
}

output "address" {
  value = aws_db_instance.rds[0].address
}
