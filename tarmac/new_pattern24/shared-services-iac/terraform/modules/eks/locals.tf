locals {

  oidc_provider = replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")

}