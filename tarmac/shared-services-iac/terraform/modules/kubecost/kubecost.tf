resource "helm_release" "kubecost_helm_release_module" {
  name             = var.kubecost_release_name
  namespace        = var.kubecost_release_namespace
  create_namespace = true
  repository       = var.kubecost_chart_repository
  chart            = var.kubecost_chart_name
  version          = var.kubecost_chart_version
  values = [
    templatefile("${path.module}/templates/values.yml", {
      storage_class = var.kubecost_storage_class,
      environment   = var.environment
    })
  ]
}
