locals {
  cluster_name = "cluster-${var.environment}-${random_string.random_string.result}"

  sso_role_arn = [
    for parts in [
      for arn in data.aws_iam_roles.sso_admin.arns : split("/", arn)
    ] : format("%s/%s", parts[0], element(parts, length(parts) - 1))
  ]
}

locals {
  argocd_url = var.environment == "prod" ? "https://argocd.cliniciannexus.com" : "https://argocd.${var.environment}.cliniciannexus.com"
}
