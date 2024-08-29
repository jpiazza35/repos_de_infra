# # Kiali is an observability console for Istio with service mesh configuration and validation capabilities.
# # It helps you understand the structure and health of your service mesh by monitoring traffic flow to infer the topology and report errors.
# # Kiali provides detailed metrics and a basic Grafana integration, 
# which can be used for advanced queries. Distributed tracing is provided by integration with Jaeger.


resource "helm_release" "kiali" {
  name             = var.kiali_release_name
  namespace        = var.istio_namespace
  repository       = var.kiali_chart_repository
  chart            = var.kiali_chart_name
  create_namespace = var.create_kiali_namespace

  set {
    name  = "cr.create"
    value = var.create_custom_kiali_resources
  }

  set {
    name  = "--create-namespace"
    value = var.create_kiali_namespace
  }
  set {
    name  = "cr.namespace"
    value = "istio-system"
  }
  set {
    name  = "auth.strategy"
    value = var.kiali_auth_strategy
  }
}

