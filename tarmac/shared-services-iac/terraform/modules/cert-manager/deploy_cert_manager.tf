resource "kubernetes_namespace" "cert_manager" {

  metadata {
    name = var.cert_manager_release_namespace
    annotations = {
      name = var.cert_manager_release_namespace
    }

    labels = {
      ns = var.cert_manager_release_namespace
    }
  }
}

resource "helm_release" "cert_manager" {
  count = 1

  name       = var.cert_manager_release_name
  namespace  = kubernetes_namespace.cert_manager.id
  chart      = var.cert_manager_chart_name
  repository = var.cert_manager_chart_repository
  version    = var.cert_manager_chart_version

  force_update     = false
  create_namespace = true
  skip_crds        = false

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cert_manager.arn
  }

  set {
    name  = "securityContext.fsGroup"
    value = "1001"
  }

}

resource "helm_release" "issuer" {
  count = 1

  name      = "certs"
  namespace = kubernetes_namespace.cert_manager.id
  chart     = "${path.module}/certs"

  force_update    = false
  cleanup_on_fail = true
  recreate_pods   = false
  reset_values    = false
  skip_crds       = false

  values = [
    local.issuer_helm_chart_values
  ]

  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubernetes_service_account" "selfSigned" {
  metadata {
    name      = "vault-cert-issuer"
    namespace = kubernetes_namespace.cert_manager.id
  }
  secret {
    name = "vault-cert-issuer"
  }
  automount_service_account_token = true

  depends_on = [
    helm_release.cert_manager
  ]
}

resource "kubernetes_secret" "selfSigned" {
  metadata {
    name      = "vault-cert-issuer"
    namespace = kubernetes_namespace.cert_manager.id
    annotations = {
      "kubernetes.io/service-account.name"      = "vault-cert-issuer"
      "kubernetes.io/service-account.namespace" = kubernetes_namespace.cert_manager.id
    }
  }
  type = "kubernetes.io/service-account-token"

  depends_on = [
    helm_release.cert_manager
  ]
}

