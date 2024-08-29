resource "kubernetes_manifest" "virtual_services" {
  count = var.istio_ingress_enabled ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/templates/virtual_services.yaml", {
    istio_gw_name          = var.istio_gw_name
    istio_namespace        = var.istio_namespace
    istio_vs_namespace     = var.istio_vs_namespace
    istio_ingress_hostname = var.istio_ingress_hostname
    mpt_ui_vs_name         = var.mpt_ui_vs_name
    mpt_ui_vs_port_number  = var.mpt_ui_vs_port_number
  }))

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubernetes_manifest" "destination_rules" {
  count = var.istio_ingress_enabled ? 1 : 0
  manifest = yamldecode(templatefile("${path.module}/templates/destination_rules.yaml", {
    istio_vs_namespace     = var.istio_vs_namespace
    mpt_ui_vs_name         = var.mpt_ui_vs_name
    mpt_ui_vs_port_number  = var.mpt_ui_vs_port_number
    istio_cert_secret_name = var.istio_cert_secret_name
  }))

  depends_on = [
    kubernetes_manifest.virtual_services
  ]
}
