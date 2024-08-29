output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.eks.cluster_id
}

output "certificate-authority" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "id" {
  description = "EKS ID"
  value       = aws_eks_cluster.eks.id
}