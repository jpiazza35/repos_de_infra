data "aws_region" "current" {}

data "aws_eks_clusters" "cluster" {}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name[0]
}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_nodes_sts_grafana" {

  statement {

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.cluster_name[0]}-worker-node-eks-node-group"]
    }

  }
}

## Find Node Instance Profile
data "aws_iam_instance_profiles" "node" {
  role_name = format("%s-worker-node-eks-node-group", local.cluster_name[0])
}

data "aws_iam_instance_profile" "node" {
  for_each = data.aws_iam_instance_profiles.node.names
  name     = each.value
}

## Thanos
data "aws_iam_policy_document" "thanos" {
  statement {
    sid = "thanosobjstore"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.thanos.arn}/*",
      "${aws_s3_bucket.thanos.arn}"
    ]
  }

}

data "aws_iam_policy_document" "eks_oidc_thanos" {

  statement {

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_provider}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.monitoring_namespace}:thanos-ruler"]
    }

  }
}

### ServiceMonitor
data "kubectl_file_documents" "argocd" {
  content = templatefile("${path.module}/templates/argocd.yml", {
    argocd_release_namespace = var.argocd_release_namespace
    prometheus_release_name  = var.prometheus_release_name
  })
}

data "vault_generic_secret" "grafana_gh_oauth" {
  path = "${var.environment}/grafana"
}