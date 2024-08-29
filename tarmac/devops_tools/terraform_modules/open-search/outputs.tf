output "opensearch_domain_name" {
  description = "The domain name of the Open Search cluster."
  value       = element(concat(aws_elasticsearch_domain.open_search.*.domain_name, tolist([""])), 0)
}

output "opensearch_cluster_arn" {
  description = "The ARN of the Open Search cluster."
  value       = element(concat(aws_elasticsearch_domain.open_search.*.arn, tolist([""])), 0)
}

output "opensearch_cluster_endpoint" {
  description = "The VPC endpoint of the Open Search cluster."
  value       = element(concat(aws_elasticsearch_domain.open_search.*.endpoint, tolist([""])), 0)
}

output "opensearch_sg_id" {
  description = "The ID of the Open Search cluster security group."
  value       = element(concat(aws_security_group.open_search.*.id, tolist([""])), 0)
}

output "opensearch_lambda_iam_role_arn" {
  description = "The ARN of the Lambda function used to send logs to Opensearch."
  value       = element(concat(aws_iam_role.lambda_os.*.arn, tolist([""])), 0)
}

output "opensearch_lambdas_sg_id" {
  description = "The security group ID of the Opensearch Lambda functions."
  value       = element(concat(aws_security_group.os_lambdas.*.id, tolist([""])), 0)
}

output "lambda_to_os_arn" {
  description = "The ARN of the Lambda function sending logs to Opensearch."
  value       = element(concat(aws_lambda_function.logs_to_os.*.arn, tolist([""])), 0)
}