output "private_subnet" {
  description = "The first subnet ID of the subnets list."
  value       = element(aws_subnet.example-account_private.*.id, 0)
}

output "private_subnets" {
  description = "The IDs of all private subnets in the VPC."
  value       = aws_subnet.example-account_private.*.id
}

output "private_subnets_cidr_blocks" {
  description = "The cidr blocks of all private subnets in the VPC."
  value       = aws_subnet.example-account_private.*.cidr_block
}

output "private_availability_zones" {
  description = "The private availability zones."
  value       = [aws_subnet.example-account_private.*.availability_zone]
}

output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.example-account_vpc.id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block."
  value       = aws_vpc.example-account_vpc.cidr_block
}

output "private_route_tables_ids" {
  description = "The public route tables IDs."
  value       = aws_route_table.example-account_private.*.id
}

output "s3_vpc_endpoint_id" {
  description = "The s3 VPC endpoint ID."
  value       = aws_vpc_endpoint.private_s3.*.id
}


output "s3_vpc_endpoint_prefix_id" {
  description = "The s3 VPC endpoint prefix list ID."
  value       = aws_vpc_endpoint.private_s3.*.prefix_list_id
}

output "vpc_endpoints_sg_id" {
  description = "The VPC endpoints SG ID."
  value       = aws_security_group.example-account_vpc.id
}

output "secrets_vpc_endpoint_id" {
  description = "The secrets VPC endpoint ID."
  value       = aws_vpc_endpoint.private_secrets.*.id
}

output "sqs_vpc_endpoint_id" {
  description = "The SQS VPC endpoint ID."
  value       = aws_vpc_endpoint.private_sqs.*.id
}