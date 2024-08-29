
resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-node"
  node_role_arn   = aws_iam_role.node-group-role.arn
  subnet_ids      = var.private_subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.des_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  /* remote_access {
    source_security_group_ids = [aws_security_group.eks_node_group_sg.id]
  } */

  tags = {
    Name                            = "${var.cluster_name}-node"
    ASG_METRICS_COLLLECTION_ENABLED = "true"
    Environment                     = "${var.environment}"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.eks,
    kubectl_manifest.aws_auth,
    aws_iam_role_policy_attachment.node-EKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-EKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-EC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node-AmazonEBSCSIDriverPolicy
  ]
}


resource "null_resource" "kubectl_update" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
  }
  depends_on = [aws_eks_node_group.main]
}
