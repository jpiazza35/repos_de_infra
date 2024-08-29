data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cert_manager_role_trust_policy" {
  statement {
    sid = "AssumeEKS"

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/AF03FA7C75D4B7A9FEE760655680D752"]
    }

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${var.aws_region}.amazonaws.com/id/AF03FA7C75D4B7A9FEE760655680D752:sub"
      values   = ["serviceaccount:${var.cert_manager_namespace}:${var.cert_manager_release_name}"]
    }
  }
}

data "aws_iam_policy_document" "cert_manager_role_access_policy" {
  statement {
    sid = "AllowAssumeDNSManagerRole"

    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:iam::836442743669:role/dns-manager",
    ]
  }
}