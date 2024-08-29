output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "eks cluster kubernetes certificate"
  value       = module.eks.cluster_certificate_authority_data
}

output "lambda_function_arn" {
  description = "ASG Metrics Lambda ARN."
  value       = aws_lambda_function.lambda_function.arn
}

output "lambda_role_arn" {
  description = "ASG Metrics Lambda IAM role ARN."
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_policy_arn" {
  description = "ASG Metrics Lambda IAM policy ARN."
  value       = aws_iam_policy.lambda_policy.arn
}

output "cloudwatch_rule_arn" {
  value = aws_cloudwatch_event_rule.create_nodegroup_rule.arn
}