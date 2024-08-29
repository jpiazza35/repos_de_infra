module "benchmarks_sql_endpoint" {
  source = "../modules/sql_warehouse"
  name   = "benchmarks-sql-endpoint"
  tags   = local.tags
}

module "benchmarks_endpoint_permissions" {
  source          = "../modules/permissions/sql_warehouse"
  sql_endpoint_id = module.benchmarks_sql_endpoint.id
  workspace       = terraform.workspace
  additional_service_principal_permissions = [
    {
      service_principal_name = databricks_service_principal.benchmarks_sp.application_id
      permission_level       = "CAN_USE"
    }
  ]
}

# DEPRECATED: update any dependent uses to benchmarks_secret_devops_vault
resource "vault_generic_secret" "benchmarks_secret" {
  data_json = jsonencode(module.benchmarks_sql_endpoint)
  path      = "data_platform/${module.workspace_vars.env}/databricks/sql_endpoints/benchmarks"
}
