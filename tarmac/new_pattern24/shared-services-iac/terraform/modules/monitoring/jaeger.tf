resource "helm_release" "jaeger_operator" {
  repository  = var.jaeger_chart_repository
  name        = var.jaeger_release_name
  namespace   = var.monitoring_namespace
  chart       = var.jaeger_chart_name
  version     = var.jaeger_chart_version
  timeout     = 360
  max_history = var.helm_releases_max_history
  skip_crds   = false

  values = [
    templatefile("${path.module}/templates/jaeger.yml",
      {
        ns = var.monitoring_namespace
      }
    )
  ]

  depends_on = [
    helm_release.elasticsearch,
    helm_release.elasticsearch_client,
    helm_release.elasticsearch_data
  ]
}
