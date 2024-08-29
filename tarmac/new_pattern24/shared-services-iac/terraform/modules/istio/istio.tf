resource "null_resource" "istio" {
  depends_on = [
    module.istio_acm
  ]

  triggers = {
    manifest = local_file.istio.content
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/templates/istio_manifests.yml"
  }
}

resource "null_resource" "istio_service_monitor" {
  depends_on = [
    helm_release.istio_ingress,
    local_file.addon
  ]

  triggers = {
    manifest = local_file.addon.content
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/templates/istio_addon.yml"
  }
}


