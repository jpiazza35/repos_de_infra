resource "helm_release" "kiali_operator" {
  name             = var.kiali_helm_chart_name
  chart            = var.kiali_helm_chart_release_name
  repository       = var.kiali_helm_chart_repo
  version          = var.kiali_helm_chart_version
  namespace        = var.kiali_helm_chart_release_name
  create_namespace = var.create_namespace
  max_history      = var.max_history

  values = [
    templatefile("${path.module}/templates/kiali.yml",
      {
        ns       = var.helm_namespace
        istio_ns = var.istio_namespace
      }
    )
  ]
}

resource "kubernetes_service_account" "kiali" {
  metadata {
    name        = "kiali"
    namespace   = var.istio_namespace
    annotations = {}
    labels = {
      istio-injection = "enabled"
    }
  }
  secret {
    name = "kiali"
  }
  automount_service_account_token = true
}

resource "kubernetes_secret" "kiali" {
  metadata {
    name      = "kiali"
    namespace = var.istio_namespace
    annotations = {
      "kubernetes.io/service-account.name" = "kiali"
    }
  }
  type = "kubernetes.io/service-account-token"
}
