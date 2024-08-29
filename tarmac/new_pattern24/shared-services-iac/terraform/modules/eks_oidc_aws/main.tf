resource "aws_iam_role" "eks" {
  count = var.enabled && var.create_oidc_provider ? length(var.eks_provider_urls) : 0

  assume_role_policy    = data.aws_iam_policy_document.assume_role[count.index].json
  description           = "Role assumed by the EKS OIDC provider."
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  name                  = local.iam_role_name
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "ecr_ro" {
  count = var.enabled && var.create_oidc_provider ? length(var.eks_provider_urls) : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks[count.index].id
}

resource "aws_iam_openid_connect_provider" "eks" {
  count = var.enabled && var.create_oidc_provider ? length(var.eks_provider_urls) : 0

  client_id_list = ["sts.amazonaws.com"]

  tags = var.tags
  thumbprint_list = [
    data.tls_certificate.eks[count.index].certificates[0].sha1_fingerprint
  ]
  url = "https://${var.eks_provider_urls[count.index]}"
}
