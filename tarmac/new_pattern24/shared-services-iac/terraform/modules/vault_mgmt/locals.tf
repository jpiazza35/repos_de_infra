locals {
  oidc_arn = [
    for arn in data.aws_iam_roles.oidc.arns : arn
  ]

  count = var.env == "shared_services" ? 1 : 0

  create_k8s_auth = var.cluster_name != "" ? 1 : 0

  create_aws_auth = var.create_aws_auth ? 1 : 0

}
