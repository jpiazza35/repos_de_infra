## SA IAM Role
resource "aws_iam_role" "sa_iam_role" {
  name                  = format("%s-sa-iam-role", lower(local.cluster_name))
  assume_role_policy    = data.aws_iam_policy_document.assume_role_sa_iam.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "sa_iam" {
  role       = aws_iam_role.sa_iam_role.id
  policy_arn = aws_iam_policy.sa_iam_policy.arn
}

resource "aws_iam_policy" "sa_iam_policy" {
  name   = format("%s-sa-iam-policy", lower(local.cluster_name))
  path   = "/"
  policy = data.aws_iam_policy_document.sa_iam_permissions.json
}

data "aws_iam_policy_document" "sa_iam_permissions" {

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "iam:CreateRole",
      "iam:PutRolePolicy",
      "iam:AttachRolePolicy",
      "iam:CreatePolicy",
      "iam:GetRole",
      "iam:UpdateAssumeRolePolicy"
    ]
  }

}


data "aws_iam_policy_document" "assume_role_sa_iam" {

  statement {

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"
      identifiers = [
        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values = [
        "system:serviceaccount:default:iam"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

  }
}



resource "kubernetes_service_account" "sa_iam" {
  metadata {
    name      = "iam"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.sa_iam_role.arn
    }
  }
}
