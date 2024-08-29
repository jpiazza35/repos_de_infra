resource "helm_release" "metrics_server" {

  name       = var.metric_server_release_name
  repository = var.metric_server_chart_repository
  chart      = var.metric_server_chart_name
  version    = var.metric_server_chart_version
  namespace  = var.metric_server_release_namespace

  recreate_pods   = var.helm_recreate_pods
  cleanup_on_fail = var.helm_cleanup_on_fail
  timeout         = var.helm_release_timeout_seconds
  max_history     = var.max_history
  skip_crds       = var.helm_skip_crds

  values = [
    file("${path.module}/templates/metrics_server.yml")
  ]

}
