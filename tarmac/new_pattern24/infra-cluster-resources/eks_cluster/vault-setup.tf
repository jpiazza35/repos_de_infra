resource "kubernetes_secret" "vault_token" {
  metadata {
    name = "vault-token"
  }

  data = {
    token = data.vault_generic_secret.env_vault_token.data["token"]
  }

  depends_on = [module.eks_mgmt]

}



