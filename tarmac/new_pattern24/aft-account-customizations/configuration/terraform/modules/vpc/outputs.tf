output "vpc" {
  description = "The VPC that was created."
  value       = aws_vpc.vpc
}

output "private_subnets" {
  description = "The private subnets that were created."
  value = try(
    aws_subnet.private, []
  )
}

output "public_subnets" {
  value = try(
    aws_subnet.public, []
  )
  description = "The public subnets that were created."
}

output "transit_subnets" {
  description = "The transit subnets that were created."
  value = try(
    aws_subnet.transit, []
  )
}

output "local_subnets" {
  description = "The local subnets that were created."
  value = try(
    aws_subnet.local, []
  )
}
