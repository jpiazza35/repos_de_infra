output "iam_role_arn" {
  depends_on = [
    aws_iam_role.eks
  ]
  description = "ARN of the IAM role."
  value       = var.enabled ? aws_iam_role.eks[0].arn : null
}
