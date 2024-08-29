output "subnet_ids" {
  description = "Private subnets"
  value       = values(aws_subnet.all)[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}