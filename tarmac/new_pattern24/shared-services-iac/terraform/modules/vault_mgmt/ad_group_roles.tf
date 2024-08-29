## Access via admins role
resource "vault_jwt_auth_backend_role" "admins" {
  count         = local.count
  backend       = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name     = "controller"
  groups_claim  = "groups"
  token_ttl     = 7200
  token_max_ttl = 14400
  token_policies = [
    vault_policy.admin_policy[count.index].name,
    "default"
  ]
  user_claim = "email"
  role_type  = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}

## Access via Readers role
resource "vault_jwt_auth_backend_role" "readers" {
  count     = local.count
  backend   = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name = "readers"
  token_policies = [
    vault_policy.kv_read[count.index].name,
  ]
  user_claim   = "email"
  groups_claim = "groups"
  role_type    = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}

## Access via devs role
resource "vault_jwt_auth_backend_role" "ces_devs" {
  count         = local.count
  backend       = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name     = "ces-devs"
  groups_claim  = "groups"
  token_ttl     = 7200
  token_max_ttl = 14400
  token_policies = [
    vault_policy.ces_devs[count.index].name,
  ]
  user_claim = "email"
  role_type  = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}

## Access via devops role
resource "vault_jwt_auth_backend_role" "devops" {
  count         = local.count
  backend       = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name     = "devops"
  groups_claim  = "groups"
  token_ttl     = 7200
  token_max_ttl = 14400
  token_policies = [
    vault_policy.devops[count.index].name,
    "default"
  ]
  user_claim = "email"
  role_type  = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}

## Access via data_platform role
resource "vault_jwt_auth_backend_role" "dp" {
  count         = local.count
  backend       = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name     = "data-platform"
  groups_claim  = "groups"
  token_ttl     = 7200
  token_max_ttl = 14400
  token_policies = [
    vault_policy.data_platform[count.index].name,
    "default"
  ]
  user_claim = "email"
  role_type  = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}

## Access via itops role
resource "vault_jwt_auth_backend_role" "itops" {
  count         = local.count
  backend       = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name     = "itops"
  groups_claim  = "groups"
  token_ttl     = 7200
  token_max_ttl = 14400
  token_policies = [
    vault_policy.itops[count.index].name,
    "default"
  ]
  user_claim = "email"
  role_type  = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}

resource "vault_jwt_auth_backend_role" "app_devs" {
  count         = local.count
  backend       = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name     = "app-devs"
  groups_claim  = "groups"
  token_ttl     = 7200
  token_max_ttl = 14400
  token_policies = [
    vault_policy.app_devs[count.index].name,
    "default"
  ]
  user_claim = "email"
  role_type  = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}

resource "vault_jwt_auth_backend_role" "qa" {
  count         = local.count
  backend       = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name     = "qa"
  groups_claim  = "groups"
  token_ttl     = 7200
  token_max_ttl = 14400
  token_policies = [
    vault_policy.qa_team[count.index].name,
    "default"
  ]
  user_claim = "email"
  role_type  = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}

resource "vault_jwt_auth_backend_role" "data_governance" {
  count         = local.count
  backend       = vault_jwt_auth_backend.azure_oidc[count.index].path
  role_name     = "data-governance"
  groups_claim  = "groups"
  token_ttl     = 7200
  token_max_ttl = 14400
  token_policies = [
    vault_policy.data_governance[count.index].name,
    "default"
  ]
  user_claim = "email"
  role_type  = "oidc"
  allowed_redirect_uris = [
    "https://vault.cliniciannexus.com:8200/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback"
  ]
  oidc_scopes = [
    "https://graph.microsoft.com/.default"
  ]
}