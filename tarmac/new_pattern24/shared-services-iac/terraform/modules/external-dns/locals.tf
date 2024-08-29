locals {

  oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")

  cluster_name = var.cluster_name == "" ? [
    for c in [
      for eks in data.aws_eks_clusters.cluster.names : eks
    ] : c
  ] : [var.cluster_name]

}
