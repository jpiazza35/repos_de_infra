## Create Service Account for Vault Auth
resource "kubernetes_service_account" "vault_auth" {
  metadata {
    name = var.k8s_serviceaccount
  }
  secret {
    name = var.k8s_serviceaccount
  }

}

resource "kubernetes_secret" "vault_auth" {
  metadata {
    name = var.k8s_serviceaccount
    annotations = {
      "kubernetes.io/service-account.name" = var.k8s_serviceaccount
    }
  }
  type = "kubernetes.io/service-account-token"
}

## Create ClusterRoleBinding for the ServiceAccount
resource "kubernetes_cluster_role_binding" "vault_auth" {
  metadata {
    name = "role-vault-external-secrets-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:auth-delegator"
  }
  subject {
    kind      = "ServiceAccount"
    name      = var.k8s_serviceaccount
    namespace = "default"
  }
}

resource "helm_release" "vault_external_secrets" {
  name      = var.helm_release
  namespace = "default"

  repository      = var.helm_repository
  recreate_pods   = true
  force_update    = true
  cleanup_on_fail = true

  chart = "external-secrets"

  timeout = var.helm_release_timeout_seconds

  set {
    name  = "replicaCount"
    value = var.injector_replicas
  }

  set {
    name  = "leaderElect"
    value = var.enable_injector_leader
  }

  set {
    name  = "installCRDs"
    value = true
  }

}
