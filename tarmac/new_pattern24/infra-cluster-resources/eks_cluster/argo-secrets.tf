
data "vault_generic_secret" "argocd" {
  path = "${var.environment}/argocd"
}

resource "kubernetes_secret" "argocd" {
  metadata {
    name      = "argocd"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    "GITHUB_OIDC_CLIENT_ID"     = data.vault_generic_secret.argocd.data["gh_oidc_clientID"]
    "GITHUB_OIDC_CLIENT_SECRET" = data.vault_generic_secret.argocd.data["gh_oidc_clientSecret"]
  }
  type = "Opaque"
}

resource "kubernetes_secret" "argocd-helm-charts-repository" {
  metadata {
    name      = "argocd-helm-charts-repository"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    "githubAppID"             = data.vault_generic_secret.argocd.data["gh_app_id"]
    "githubAppInstallationID" = data.vault_generic_secret.argocd.data["gh_app_installation_id"]
    "githubAppPrivateKey"     = data.vault_generic_secret.argocd.data["gh_ssh_private_key"]
    "type"                    = "git"
    "url"                     = "https://github.com/clinician-nexus/helm-charts"
  }
  type = "Opaque"
}

resource "kubernetes_secret" "argocd-kubernetes-repository" {
  metadata {
    name      = "argocd-kubernetes-repository"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    "githubAppID"             = data.vault_generic_secret.argocd.data["gh_app_id"]
    "githubAppInstallationID" = data.vault_generic_secret.argocd.data["gh_app_installation_id"]
    "githubAppPrivateKey"     = data.vault_generic_secret.argocd.data["gh_ssh_private_key"]
    "type"                    = "git"
    "url"                     = "https://github.com/clinician-nexus/kubernetes"
  }
  type = "Opaque"
}


resource "kubernetes_secret" "argocd-notifications-secret" {
  metadata {
    name      = "argocd-notifications-secret"
    namespace = "argocd"
  }

  data = {
    "slack-token" = data.vault_generic_secret.argocd.data["slack_token"]
  }
  type = "Opaque"
}
