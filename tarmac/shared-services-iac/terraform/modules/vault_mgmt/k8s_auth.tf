resource "vault_auth_backend" "kubernetes" {
  count = local.create_k8s_auth
  type  = "kubernetes"
  path  = var.cluster_name
}

resource "vault_kubernetes_auth_backend_config" "k8s" {
  count                  = local.create_k8s_auth
  backend                = vault_auth_backend.kubernetes[count.index].path
  kubernetes_host        = data.aws_eks_cluster.cluster[count.index].endpoint
  kubernetes_ca_cert     = base64decode(data.aws_eks_cluster.cluster[count.index].certificate_authority[0].data)
  token_reviewer_jwt     = data.kubernetes_secret.sa[count.index].data["token"]
  issuer                 = data.aws_eks_cluster.cluster[count.index].identity[0].oidc[0].issuer
  disable_iss_validation = true

  lifecycle {
    ignore_changes = [
      kubernetes_ca_cert,
      token_reviewer_jwt,
      issuer,
      kubernetes_host
    ]
  }
}

resource "vault_kubernetes_auth_backend_role" "k8s" {
  count     = local.create_k8s_auth
  backend   = vault_auth_backend.kubernetes[count.index].path
  role_name = var.cluster_name
  bound_service_account_names = [
    var.k8s_serviceaccount,
    "default"
  ]
  bound_service_account_namespaces = [
    "*"
  ]
  token_ttl = 86400 #24h
  token_policies = [
    "default",
    vault_policy.k8s[count.index].name
  ]
}

### Create a cluster role with limited access and assign it to the github actions aws role
resource "kubernetes_cluster_role" "github_actions" {
  count = local.create_k8s_auth
  metadata {
    name = "github-actions"
  }

  // RO resources
  rule {
    api_groups = ["*"]

    resources = [
      "*"
    ]

    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  // RW resources
  rule {
    api_groups = ["*"]

    resources = [
      "*"
    ]

    verbs = [
      "create",
      "delete",
      "patch",
      "update",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "github_actions" {
  count = local.create_k8s_auth
  metadata {
    name = "github-actions"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.github_actions[count.index].metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "deployers"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = local.oidc_arn[0]
    api_group = "rbac.authorization.k8s.io"
  }

  lifecycle {
    ignore_changes = [
      subject["name"]
    ]
  }

}

## Vault Cert Issuer PKI Role
resource "vault_kubernetes_auth_backend_role" "vault_cert_issuer" {
  count     = local.create_k8s_auth
  backend   = vault_auth_backend.kubernetes[count.index].path
  role_name = "vault-cert-issuer"
  bound_service_account_names = [
    var.k8s_cert_issuer_serviceaccount,
    "default"
  ]
  bound_service_account_namespaces = [
    "*"
  ]
  token_ttl = 86400 #24h
  token_policies = [
    "default",
    vault_policy.pki_cert_issuer[count.index].name
  ]
}
