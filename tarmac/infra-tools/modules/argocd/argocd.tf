resource "helm_release" "argocd_helm_release_module" {
  name              = var.argocd_release_name
  namespace         = var.argocd_release_namespace
  repository        = var.argocd_chart_repository
  dependency_update = var.dependency_update
  chart             = var.argocd_chart_name
  version           = var.argocd_chart_version

  #Using default values to test installation
  set {
    name  = "cluster.enabled"
    value = var.set_cluster_enabled
  }

}

##argocd-cm.yaml File
resource "null_resource" "sso_argocd_cm" {
  count = var.argocd_sso_integration_enabled ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.sso_argocd_cm[0].rendered}\nEOF"

  }
  depends_on = [helm_release.argocd_helm_release_module]
}

data "template_file" "sso_argocd_cm" {
  count = var.argocd_sso_integration_enabled ? 1 : 0

  template = file("${path.module}/sso-integration/templates/argocd-cm.yaml")
  vars = {
    argocd_release_namespace         = var.argocd_release_namespace
    argocd_domain_name               = var.argocd_sso_integration_domain_name
    argocd_sso_integration_clientid  = var.argocd_sso_integration_clientid
    argocd_sso_integration_tennantid = var.argocd_sso_integration_tennantid
    argocd_chart_version             = var.argocd_chart_version
  }

}

##argocd-secret.yaml File
resource "null_resource" "sso_argocd_secret" {
  count = var.argocd_sso_integration_enabled ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.sso_argocd_secret[0].rendered}\nEOF"

  }
  depends_on = [helm_release.argocd_helm_release_module]
}

data "template_file" "sso_argocd_secret" {
  count = var.argocd_sso_integration_enabled ? 1 : 0

  template = file("${path.module}/sso-integration/templates/argocd-secret.yaml")
  vars = {
    argocd_release_namespace             = var.argocd_release_namespace
    argocd_chart_version                 = var.argocd_chart_version
    argocd_release_name                  = var.argocd_release_name
    argocd_sso_integration_client_secret = var.argocd_sso_integration_client_secret

  }

}

##argocd-rbac-cm.yaml File
resource "null_resource" "sso_argocd_rbac_cm" {
  count = var.argocd_sso_integration_enabled ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.sso_argocd_rbac_cm[0].rendered}\nEOF"

  }
  depends_on = [helm_release.argocd_helm_release_module]
}

data "template_file" "sso_argocd_rbac_cm" {
  count = var.argocd_sso_integration_enabled ? 1 : 0

  template = file("${path.module}/sso-integration/templates/argocd-rbac-cm.yaml")
  vars = {
    argocd_release_namespace        = var.argocd_release_namespace
    argocd_release_name             = var.argocd_release_name
    argocd_chart_version            = var.argocd_chart_version
    argocd_sso_integration_group_id = var.argocd_sso_integration_group_id

  }

}

###Delete current argocd_notifications_cm before creating it again
resource "null_resource" "delete_argocd_notifications_cm" {
  count = var.argocd_slack_notifications_enabled ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl delete cm argocd-notifications-cm -n mpt-apps"

  }
  depends_on = [helm_release.argocd_helm_release_module]
}

###argocd-notifications-cm.yaml File
resource "kubernetes_manifest" "argocd_notifications_cm" {
  count    = var.argocd_slack_notifications_enabled ? 1 : 0
  manifest = yamldecode(data.template_file.argocd_notifications_cm[0].rendered)

  depends_on = [helm_release.argocd_helm_release_module,
  null_resource.delete_argocd_notifications_cm]
}

data "template_file" "argocd_notifications_cm" {
  count = var.argocd_slack_notifications_enabled ? 1 : 0

  template = file("${path.module}/slack-notifications/templates/argocd-notifications-cm.yaml")
  vars = {
    argocd_release_namespace = var.argocd_release_namespace
    argocd_release_name      = var.argocd_release_name
    argocd_chart_version     = var.argocd_chart_version
  }

}

###argocd-notifications-secret.yaml File
resource "null_resource" "argocd_notifications_secret" {
  count = var.argocd_slack_notifications_enabled ? 1 : 0
  provisioner "local-exec" {
    command = "kubectl apply -f -<<EOF\n${data.template_file.argocd_notifications_secret[0].rendered}\nEOF"

  }

  depends_on = [helm_release.argocd_helm_release_module]
}

data "template_file" "argocd_notifications_secret" {
  count = var.argocd_slack_notifications_enabled ? 1 : 0

  template = file("${path.module}/slack-notifications/templates/argocd-notifications-secret.yaml")
  vars = {
    argocd_release_namespace                = var.argocd_release_namespace
    argocd_slack_notifications_slack_secret = var.argocd_slack_notifications_slack_secret


  }

}