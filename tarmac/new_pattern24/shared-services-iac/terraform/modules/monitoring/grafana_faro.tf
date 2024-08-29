# resource "helm_release" "grafana_faro" {

#   name       = var.faro_release_name
#   chart      = var.faro_chart_name
#   repository = var.faro_chart_repository
#   namespace  = var.monitoring_namespace
#   version    = var.faro_chart_version
#   timeout    = 300
#   skip_crds  = false

#   values = [
#     file("${path.module}/templates/grafana_faro_values.yml")
#   ]

#   depends_on = [
#     helm_release.prometheus
#   ]
# }

# resource "kubectl_manifest" "grafana_faro_manifest" {
#   for_each  = data.kubectl_file_documents.grafana_faro.manifests
#   yaml_body = each.value
#   depends_on = [
#     helm_release.grafana_faro
#   ]
# }

#