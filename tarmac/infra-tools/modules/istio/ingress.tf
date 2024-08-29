resource "kubernetes_manifest" "ingress" {
  count = var.istio_ingress_enabled ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/templates/ingress.yaml", {
    istio_namespace         = var.istio_namespace
    istio_ingress_hostname  = var.istio_ingress_hostname
    istio_ingress_name      = var.istio_ingress_name
    istio_ingress_helm_name = var.istio_ingress_helm_name
    istio_gw_port_name      = var.istio_gw_port_name
    istio_cert_secret_name  = var.istio_cert_secret_name
  }))

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod,
    helm_release.istio_ingress
  ]
}
