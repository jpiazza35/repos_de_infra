# // Export the Databricks personal access token's value, for integration tests to run on.
# output "databricks_token" {
#   value     = databricks_token.pat[*].token_value
#   sensitive = true
# }

output "databricks_workspace_token" {
  value     = databricks_mws_workspaces.workspace[*].token[*].token_value
  sensitive = true
}

// Capture the Databricks workspace's URL.
output "databricks_host" {
  value = element(databricks_mws_workspaces.workspace[*].workspace_url, 0)
}

// Azure App Registration
output "app_role_ids" {
  value = azuread_application.main.app_role_ids
}

output "application_id" {
  value = azuread_application.main.application_id
}

output "display_name" {
  value = azuread_application.main.display_name
}

output "group_assignments" {
  value = [
    for a in data.azuread_group.assignment : a.display_name
  ]
}

output "redirect_uris" {
  value = azuread_application.main.web[0].redirect_uris
}

output "local_groups" {
  value = ""
  /* ## For a list output [
    for g in local.ad_group_assignments: g["g"]
  ]
 ## For a map output {
    for g in local.ad_group_assignments: g.g => g.g
  }  */
}

output "service_account_credentials" {
  value = {
    sp_name   = databricks_service_principal.admin.display_name
    sp_token  = databricks_service_principal_secret.admin.secret
    sensitive = true
  }
}