output "vault_path" {
  value = vault_generic_secret.token_secret.path
}


output "token" {
  value     = databricks_obo_token.token.token_value
  sensitive = true
}
