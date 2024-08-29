data "aws_partition" "current" {
  count = local.default
}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled && var.create_oidc_provider ? length(var.eks_provider_urls) : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      identifiers = [
        aws_iam_openid_connect_provider.eks[count.index].arn
      ]
      type = "Federated"
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "${var.eks_provider_urls[count.index]}:aud"
    }
  }

  version = "2012-10-17"
}

data "aws_iam_openid_connect_provider" "eks" {
  count = var.enabled && !var.create_oidc_provider ? length(var.eks_provider_urls) : 0

  url = "https://${var.eks_provider_urls[count.index]}"
}

data "tls_certificate" "eks" {
  count = local.default
  url   = "https://oidc.eks.${var.region}.amazonaws.com/.well-known/openid-configuration"
}
