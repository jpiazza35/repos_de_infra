locals {

  oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")

}

data "aws_region" "current" {}

data "aws_eks_clusters" "cluster" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name == "" ? local.cluster_name[0] : var.cluster_name
}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_caller_identity" "ss_network" {
  provider = aws.ss_network
}

## Cert Manager
data "aws_iam_policy_document" "cert_manager" {

  statement {

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values   = ["system:serviceaccount:cert-manager:cert-manager"]
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
