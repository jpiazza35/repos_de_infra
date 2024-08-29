resource "helm_release" "confluent" {
  name      = var.confluent_release_name
  namespace = var.confluent_release_namespace

  repository       = var.confluent_repository
  recreate_pods    = true
  force_update     = true
  create_namespace = true

  chart = var.confluent_chart_name

  timeout = var.helm_release_timeout_seconds

  set {
    name  = "namespaced"
    value = false
  }

  set {
    name  = "kRaftEnabled"
    value = true
  }


}


resource "kubectl_manifest" "confluent_kraft_broker_controller" {
  for_each  = data.kubectl_file_documents.confluent_kraft_broker_controller.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent
  ]
}

resource "kubectl_manifest" "confluent_kraft_producer_app_data" {
  for_each  = data.kubectl_file_documents.confluent_kraft_producer_app_data.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent, kubectl_manifest.confluent_kraft_broker_controller
  ]
}

resource "kubectl_manifest" "confluent_confluent_platform" {
  for_each  = data.kubectl_file_documents.confluent_confluent_platform.manifests
  yaml_body = each.value
  depends_on = [
    kubectl_manifest.confluent_kraft_producer_app_data
  ]
}

resource "kubectl_manifest" "confluent_producer_app_data" {
  for_each  = data.kubectl_file_documents.confluent_producer_app_data.manifests
  yaml_body = each.value
  depends_on = [
    kubectl_manifest.confluent_confluent_platform
  ]
}

