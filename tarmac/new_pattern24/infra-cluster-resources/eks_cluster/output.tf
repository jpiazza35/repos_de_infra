output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_mgmt.cluster_endpoint
}