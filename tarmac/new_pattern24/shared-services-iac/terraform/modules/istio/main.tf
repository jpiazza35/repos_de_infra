resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = var.helm_namespace
  }
}

resource "helm_release" "istio_base" {
  name       = var.basenamechart
  namespace  = kubernetes_namespace.istio_system.metadata[0].name
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = var.chartVersion

  set {
    name  = "global.istioNamespace"
    value = kubernetes_namespace.istio_system.metadata[0].name
  }

  set {
    name  = "sidecarInjectorWebhook.rewriteAppHTTPProbe"
    value = "true"
  }

  set {
    name  = "global.controlPlaneSecurityEnabled"
    value = "true"
  }

  set {
    name  = "namespaceSelector.any"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace.istio_system
  ]

}

resource "helm_release" "istiod" {
  name       = var.istiodname
  namespace  = kubernetes_namespace.istio_system.metadata[0].name
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.chartVersion

  depends_on = [
    helm_release.istio_base
  ]

  values = [
    templatefile("${path.module}/templates/istio.yml",
      {
        ns = kubernetes_namespace.istio_system.metadata[0].name
      }
    )
  ]
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "istio-ingress"
  }
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"

  timeout         = var.helm_release_timeout_seconds
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_ingress.metadata.0.name

  set {
    name  = "autoscaling.minReplicas"
    value = var.istio_ingress_autoscaling_minReplicas
  }

  set {
    name  = "autoscaling.maxReplicas"
    value = var.istio_ingress_autoscaling_maxReplicas
  }

  set {
    name  = "service.type"
    value = var.istio_ingress_service_type
  }

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}
