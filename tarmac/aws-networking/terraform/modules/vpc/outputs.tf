output "vpc" {
  value       = aws_vpc.vpc
  description = "The VPC that was created."
}

output "private_subnets" {
  value       = try(aws_subnet.private, [])
  description = "The private subnets that were created."
}

output "public_subnets" {
  value       = try(aws_subnet.public, [])
  description = "The public subnets that were created."
}

output "transit_subnets" {
  value       = try(aws_subnet.transit, [])
  description = "The transit subnets that were created."
}

output "local_subnets" {
  value       = try(aws_subnet.local, [])
  description = "The local subnets that were created."
}