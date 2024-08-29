locals {

  cluster_name = [
    for c in [
      for eks in data.aws_eks_clusters.cluster.names : eks
    ] : c
  ]

  common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/part-of"    = var.prometheus_release_name
    "environment"                  = var.environment
  }

  runbook_base_url = var.runbook_base_url

  alertmanager_ingress = var.environment == "prod" ? format(
    "%s.%s",
    "monitoring",
    var.cluster_domain,
    ) : format(
    "%s.%s.%s",
    "monitoring",
    var.environment,
    var.cluster_domain,
  )

  grafana_root = var.environment == "prod" ? format(
    "%s.%s",
    "https://monitoring",
    var.cluster_domain,
    ) : format(
    "%s.%s.%s",
    "https://monitoring",
    var.environment,
    var.cluster_domain,
  )

  prometheus_ingress = var.environment == "prod" ? format(
    "%s.%s",
    "monitoring",
    var.cluster_domain,
    ) : format(
    "%s.%s.%s",
    "monitoring",
    var.environment,
    var.cluster_domain,
  )

  oidc_provider = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")

}
