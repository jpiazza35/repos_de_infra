resource "helm_release" "loki" {
  name       = var.loki_release_name
  chart      = var.loki_chart_name
  repository = var.loki_chart_repository
  namespace  = var.monitoring_namespace
  timeout    = 300
  skip_crds  = false

  values = [
    file("${path.module}/templates/loki.yml")
  ]
}
