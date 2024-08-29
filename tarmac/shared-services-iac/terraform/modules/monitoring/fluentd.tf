resource "helm_release" "fluentd" {
  repository    = var.fluentd_chart_repository
  name          = var.fluentd_deployment_name
  namespace     = var.monitoring_namespace
  chart         = var.fluentd_chart_name
  version       = var.fluentd_chart_version
  timeout       = 300
  skip_crds     = false
  recreate_pods = true

  values = [
    file("${path.module}/templates/fluentd.yml")
  ]

  depends_on = [
    helm_release.elasticsearch
  ]
}
