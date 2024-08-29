data "aws_region" "current" {}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_nodes_sts_grafana" {

  statement {

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-node-group-${var.cluster_name}"]
    }

  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name == "" ? local.cluster_name[0] : var.cluster_name
}

data "aws_iam_role" "eks_node" {
  name = "eks-node-group-${var.cluster_name}"
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
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
/* data "kubectl_file_documents" "argocd" {
  content = templatefile("${path.module}/templates/argocd.yml", {
    argocd_release_namespace = var.argocd_release_namespace
    prometheus_release_name  = var.prometheus_release_name
  })
} */

data "vault_generic_secret" "grafana_gh_oauth" {
  path = "${var.environment}/grafana"
}

/*
data "vault_generic_secret" "grafana_faro_credentials" {
  path = "${var.environment}/grafana-faro"
}

data "kubectl_file_documents" "grafana_faro" {
  content = templatefile("${path.module}/templates/grafana_faro.yml", {
    namespace                         = var.monitoring_namespace
    monitoring_ingress                = var.monitoring_ingress
    prometheus_release_name           = var.prometheus_release_name
    grafana_agent_image_tag           = var.grafana_agent_image_tag
    faro_credentials_metrics_user     = data.vault_generic_secret.grafana_faro_credentials.data["faro_credentials_metrics_user"]
    faro_credentials_metrics_password = data.vault_generic_secret.grafana_faro_credentials.data["faro_credentials_metrics_password"]
    faro_credentials_logs_user        = data.vault_generic_secret.grafana_faro_credentials.data["faro_credentials_logs_user"]
    faro_credentials_logs_password    = data.vault_generic_secret.grafana_faro_credentials.data["faro_credentials_logs_password"]
    ingress_monitoring_name           = var.ingress_monitoring_name

  })
}
*/
