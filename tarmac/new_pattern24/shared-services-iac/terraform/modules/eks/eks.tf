# EKS

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks-cluster-role.arn

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    endpoint_private_access = var.is_eks_api_private
    endpoint_public_access  = var.is_eks_api_public
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.services_cidr
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon-eks-cluster-policy,
    aws_cloudwatch_log_group.eks-cluser
  ]

}
