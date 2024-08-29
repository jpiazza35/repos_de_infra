resource "kubectl_manifest" "argocd_servicemonitors" {
  count     = length(data.kubectl_file_documents.argocd.documents)
  yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
}

resource "kubectl_manifest" "cni_metrics_podmonitor" {
  yaml_body = templatefile("${path.module}/templates/cni_metrics.yml",
    {
      prometheus_release_name = var.prometheus_release_name
      cni_metrics_namespace   = var.cni_metrics_namespace
  })
}
