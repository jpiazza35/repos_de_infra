resource "helm_release" "issuer" {
  count = 1
  depends_on = [
    helm_release.cert_manager
  ]

  name      = "certs"
  namespace = var.cert_manager_namespace
  chart     = "${path.module}/certs"

  force_update    = true
  cleanup_on_fail = true
  recreate_pods   = false
  reset_values    = false
  reuse_values    = true

  create_namespace = true

  values = [
    local.certs_helm_chart_values
  ]
}

resource "helm_release" "cert_manager" {
  count = 1

  name       = var.cert_manager_release_name
  namespace  = var.cert_manager_namespace
  chart      = var.cert_manager_chart_name
  repository = var.cert_manager_chart_repository

  force_update     = false
  create_namespace = true

  set {
    name  = "installCRDs"
    value = var.install_cert_manager_crds
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cert_manager.arn
  }

  set {
    name  = "securityContext.fsGroup"
    value = var.cert_manager_security_context_fsgroup
  }
}
