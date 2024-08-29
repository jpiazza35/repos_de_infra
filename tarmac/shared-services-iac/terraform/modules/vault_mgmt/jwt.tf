### Enable Github OIDC for Vault
resource "vault_jwt_auth_backend" "gha" {
  count              = local.count
  description        = "GitHub Actions JWT auth backend"
  path               = "jwt"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

resource "vault_jwt_auth_backend_role" "gha-role" {
  count     = local.count
  backend   = vault_jwt_auth_backend.gha[count.index].path
  role_name = "gha-role"
  bound_audiences = [
    "gha"
  ]
  bound_claims = {
    repository_owner = "clinician-nexus"
  }
  bound_claims_type = "glob"
  token_policies = [
    "gha-ro"
  ]
  role_type  = "jwt"
  user_claim = "actor"
}

resource "vault_policy" "gha-ro" {
  count = local.count
  name  = "gha-ro"

  policy = <<EOT
path "dev/*" {
  capabilities = [ "read", "list" ]
}

path "qa/*" {
  capabilities = [ "read", "list" ]
}

path "prod/*" {
  capabilities = [ "read", "list" ]
}

path "devops/*" {
  capabilities = [ "read", "list" ]
}

path "data_platform/*" {
  capabilities = [ "read", "list" ]
}

path "preview/*" {
  capabilities = [ "read", "list" ]
}
EOT
}
