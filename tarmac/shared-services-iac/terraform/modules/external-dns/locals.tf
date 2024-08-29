locals {

  oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")

  cluster_name = [
    for c in [
      for eks in data.aws_eks_clusters.cluster.names : eks
    ] : c
  ]

  node_role_name = [
    for n in data.aws_iam_roles.roles.names : n
  ]

  node_role_arn = [
    for a in data.aws_iam_roles.roles.arns : a
  ]

}
