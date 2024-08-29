// Export the Databricks personal access token's value, for integration tests to run on.
# output "databricks_token" {
#   value     = module.databricks_workspaces.databricks_token
#   sensitive = true
# }

output "vpc_cidr" {
  value = local.vpc_cidr
}

// Capture the Databricks workspace's URL.
output "databricks_host" {
  value = module.databricks_workspaces.databricks_host
}

output "databricks_sp_creds" {
  value     = module.databricks_workspaces.service_account_credentials
  sensitive = true
}
