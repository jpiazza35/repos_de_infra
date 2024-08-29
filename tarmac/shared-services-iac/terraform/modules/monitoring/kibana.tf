/* resource "helm_release" "kibana" {

  name        = "kibana"
  chart       = "kibana"
  repository  = "https://helm.elastic.co"
  version     = ""
  namespace   = var.monitoring_namespace
  timeout     = var.helm_releases_timeout_seconds
  max_history = var.helm_releases_max_history

  values = [
    templatefile("${path.module}/templates/kibana.yml", {})
  ]
}

resource "kubernetes_secret" "kibana" {
  metadata {
    name      = "kibana"
    namespace = var.monitoring_namespace
    annotations = {
      "kubernetes.io/service-account.name" = "kibana"
    }
  }
  type = "kubernetes.io/service-account-token"
} */
