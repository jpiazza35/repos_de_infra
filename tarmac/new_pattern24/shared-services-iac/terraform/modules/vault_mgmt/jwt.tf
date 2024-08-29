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
    "gha-ro",
    "gha-rw",
    "admins"
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

path "ss/*" {
  capabilities = [ "read", "list" ]
}

EOT
}

resource "vault_jwt_auth_backend_role" "gha-rw-role" {
  count     = local.count
  backend   = vault_jwt_auth_backend.gha[count.index].path
  role_name = "gha-rw-role"
  bound_audiences = [
    "gha"
  ]
  bound_claims = {
    repository_owner = "clinician-nexus"
  }
  bound_claims_type = "glob"
  token_policies = [
    "gha-rw"
  ]
  role_type  = "jwt"
  user_claim = "actor"
}

resource "vault_policy" "gha-rw" {
  count = local.count
  name  = "gha-rw"

  policy = <<EOT
path "dev/*" {
  capabilities = [ "read", "list", "create", "update" ]
}

path "qa/*" {
  capabilities = [ "read", "list", "create", "update" ]
}

path "prod/*" {
  capabilities = [ "read", "list", "create", "update" ]
}

path "devops/*" {
  capabilities = [ "read", "list", "create", "update" ]
}

path "data_platform/*" {
  capabilities = [ "read", "list", "create", "update" ]
}

path "ss/*" {
  capabilities = [ "read", "list", "create", "update" ]
}

EOT
}
