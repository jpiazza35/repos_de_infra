data "vault_generic_secret" "argocd" {
  path = "${var.environment}/argocd"
}

data "kubectl_file_documents" "mpt_apps" {
  content = templatefile("${path.module}/applications/mpt-apps.yml", {
    environment              = var.environment
    mpt_namespace            = var.mpt_namespace
    argocd_release_namespace = var.argocd_release_namespace
    github_branch            = var.helm_charts_branch_name
    slack_channel            = var.slack_channel
  })
}

data "kubectl_file_documents" "mpt_apps_preview" {
  content = templatefile("${path.module}/applications/mpt-apps.yml", {
    environment              = var.preview_environment
    mpt_namespace            = var.mpt_preview_namespace
    argocd_release_namespace = var.argocd_release_namespace
    github_branch            = var.helm_charts_branch_name
    slack_channel            = var.slack_channel
  })
}

data "kubectl_file_documents" "ps_apps" {
  content = templatefile("${path.module}/applications/ps-apps.yml", {
    environment              = var.environment
    ps_namespace             = var.ps_namespace
    argocd_release_namespace = var.argocd_release_namespace
    github_branch            = var.helm_charts_branch_name
    slack_channel            = var.slack_channel
  })
}

data "kubectl_file_documents" "ps_apps_preview" {
  content = templatefile("${path.module}/applications/ps-apps.yml", {
    environment              = var.preview_environment
    ps_namespace             = var.ps_preview_namespace
    argocd_release_namespace = var.argocd_release_namespace
    github_branch            = var.helm_charts_branch_name
    slack_channel            = var.slack_channel
  })
}