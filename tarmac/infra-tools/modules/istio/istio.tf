resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = var.istio_namespace
  }
}

resource "helm_release" "istio_base" {
  name       = var.istio_base_helm_name
  namespace  = kubernetes_namespace.istio_system.metadata.0.name
  repository = var.istio_chart_repository
  chart      = var.istio_base_chart_name
  version    = var.istio_chart_version

  set {
    name  = "global.istioNamespace"
    value = kubernetes_namespace.istio_system.metadata.0.name
  }

  depends_on = [kubernetes_namespace.istio_system]
}

resource "helm_release" "istiod" {
  name       = var.istiod_helm_name
  namespace  = kubernetes_namespace.istio_system.metadata.0.name
  repository = var.istio_chart_repository
  chart      = var.istiod_chart_name
  version    = var.istio_chart_version
  set {
    name  = "global.istioNamespace"
    value = kubernetes_namespace.istio_system.metadata.0.name
  }

  set {
    name  = "meshConfig.enablePrometheusMerge"
    value = true

  }

  set {
    name  = "global.prometheusEnabled"
    value = true
  }

  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name       = var.istio_ingress_helm_name
  repository = var.istio_chart_repository
  chart      = var.istio_ingress_chart_name

  timeout         = 500
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name

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

  # set {
  #   name  = "service.annotations"
  #   value = jsonencode({
  #     "alb.ingress.kubernetes.io/healthcheck-path": "/healthz/ready",
  #     "alb.ingress.kubernetes.io/healthcheck-port": "15021"
  #   })
  # }

  set {
    name  = "global.proxy.autoInject"
    value = "disabled"
  }

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}