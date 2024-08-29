resource "kubectl_manifest" "argocd_servicemonitors" {
  yaml_body = templatefile("${path.module}/templates/argocd.yml", {
    argocd_release_namespace = var.argocd_release_namespace
    prometheus_release_name  = var.prometheus_release_name
  })
}

resource "kubectl_manifest" "cni_metrics_podmonitor" {
  yaml_body = templatefile("${path.module}/templates/cni_metrics.yml",
    {
      prometheus_release_name = var.prometheus_release_name
      cni_metrics_namespace   = var.cni_metrics_namespace
  })
}
