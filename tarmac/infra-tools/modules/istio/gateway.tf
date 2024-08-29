resource "kubernetes_manifest" "gateway" {
  count = var.istio_ingress_enabled ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/templates/gateway.yaml", {
    istio_namespace        = var.istio_namespace
    istio_gw_type          = var.istio_gw_type
    istio_gw_name          = var.istio_gw_name
    istio_gw_port          = var.istio_gw_port
    istio_gw_port_name     = var.istio_gw_port_name
    istio_gw_port_protocol = var.istio_gw_port_protocol
    istio_ingress_hostname = var.istio_ingress_hostname
    istio_cert_secret_name = var.istio_cert_secret_name
  }))

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}
