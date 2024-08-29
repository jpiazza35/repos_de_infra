resource "vault_identity_group" "user" {
  count = local.count
  name  = "user"
  type  = "external"
  policies = [
    "readers",
    "devs"
  ]
}

resource "vault_identity_group" "admin" {
  count    = local.count
  name     = "admin"
  type     = "external"
  policies = ["admins"]
}


resource "vault_identity_group_alias" "user_alias_azure_vault_user" {
  count          = local.count
  name           = "VaultUser"
  mount_accessor = vault_jwt_auth_backend.azure_oidc[count.index].accessor
  canonical_id   = vault_identity_group.user[count.index].id
}

resource "vault_identity_group_alias" "admin_alias_azure_vault_admin" {
  count          = local.count
  name           = "VaultAdmin"
  mount_accessor = vault_jwt_auth_backend.azure_oidc[count.index].accessor
  canonical_id   = vault_identity_group.admin[count.index].id
}
