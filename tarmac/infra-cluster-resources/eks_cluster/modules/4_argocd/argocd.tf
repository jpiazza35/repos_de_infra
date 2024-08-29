resource "helm_release" "argocd_helm_release_module" {
  name              = var.argocd_release_name
  namespace         = var.argocd_release_namespace
  repository        = var.argocd_chart_repository
  dependency_update = var.dependency_update
  chart             = var.argocd_chart_name
  version           = var.argocd_chart_version
  create_namespace  = true
  #Using default values to test installation
  set {
    name  = "cluster.enabled"
    value = var.set_cluster_enabled
  }

  set {
    name  = "crds.keep"
    value = var.argocd_keep_crds_uninstall
  }

  depends_on = [null_resource.argocd_namespace]

}

resource "null_resource" "argocd_namespace" {

  provisioner "local-exec" {
    command = "kubectl get namespace | grep -q ${var.argocd_release_namespace} || kubectl create namespace ${var.argocd_release_namespace}"
  }
}


### argocd-notifications-cm.yaml File

resource "kubectl_manifest" "argocd_notifications_cm" {
  count = var.argocd_slack_notifications_enabled ? 1 : 0
  yaml_body = templatefile("${path.module}/slack-notifications/templates/argocd-notifications-cm.yaml",
    {
      argocd_release_namespace                = var.argocd_release_namespace
      argocd_release_name                     = var.argocd_release_name
      argocd_chart_version                    = var.argocd_chart_version
      argocd_url                              = var.argocd_url
      argocd_slack_notifications_slack_secret = var.argocd_slack_notifications_slack_secret
  })
  depends_on = [helm_release.argocd_helm_release_module]
}

### argocd-notifications-secret.yaml File

resource "kubectl_manifest" "argocd_notifications_secret" {
  count = var.argocd_slack_notifications_enabled ? 1 : 0
  yaml_body = templatefile("${path.module}/slack-notifications/templates/argocd-notifications-secret.yaml",
    {
      argocd_release_namespace                = var.argocd_release_namespace
      argocd_slack_notifications_slack_secret = var.argocd_slack_notifications_slack_secret
  })
  depends_on = [helm_release.argocd_helm_release_module]
}

### Service to allow ALB access

resource "null_resource" "service_argocd" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/custom-service.yaml -n ${var.argocd_release_namespace}"
  }
  depends_on = [helm_release.argocd_helm_release_module]
}

### argocdapp.yaml File

resource "kubectl_manifest" "argocdapps_mpt" {
  for_each  = data.kubectl_file_documents.mpt_apps.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.argocd_helm_release_module
  ]
}

resource "kubectl_manifest" "argocdapps_mpt_preview" {
  for_each  = var.environment == "prod" ? data.kubectl_file_documents.mpt_apps_preview.manifests : {}
  yaml_body = each.value
  depends_on = [
    helm_release.argocd_helm_release_module
  ]
}

resource "kubectl_manifest" "argocdapps_ps" {
  for_each  = data.kubectl_file_documents.ps_apps.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.argocd_helm_release_module
  ]
}

resource "kubectl_manifest" "argocdapps_ps_preview" {
  for_each  = var.environment == "prod" ? data.kubectl_file_documents.ps_apps_preview.manifests : {}
  yaml_body = each.value
  depends_on = [
    helm_release.argocd_helm_release_module
  ]
}

### argocd-sync-interval.yaml File

resource "kubectl_manifest" "argocd_cm" {
  yaml_body = templatefile("${path.module}/argocd-cm.yaml", {
    argocd_sync_interval_time = var.argocd_sync_interval_time
    argocd_release_name       = var.argocd_release_name
    argocd_release_namespace  = var.argocd_release_namespace
    argocd_chart_version      = var.argocd_chart_version
    argocd_client_id          = data.vault_generic_secret.argocd.data["gh_oidc_clientID"]
    argocd_client_secret      = data.vault_generic_secret.argocd.data["gh_oidc_clientSecret"]
    argocd_org_name           = data.vault_generic_secret.argocd.data["gh_oidc_orgName"]
    argocd_url                = var.argocd_url
  })

  depends_on = [
    helm_release.argocd_helm_release_module
  ]
}


resource "kubectl_manifest" "argocd_rbac_cm" {
  yaml_body = templatefile("${path.module}/argocd-rbac-cm.yaml", {
    argocd_release_namespace = var.argocd_release_namespace,
    argocd_org_name          = data.vault_generic_secret.argocd.data["gh_oidc_orgName"]
  })

  depends_on = [
    helm_release.argocd_helm_release_module
  ]
}