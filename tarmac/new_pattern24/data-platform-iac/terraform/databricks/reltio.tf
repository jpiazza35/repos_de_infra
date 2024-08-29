module "reltio_sql_endpoint" {
  source = "../modules/sql_warehouse"
  name   = "reltio-sql-endpoint"
  tags   = local.tags
}

module "reltio_warehouse_permissions" {
  source = "../modules/permissions/sql_warehouse"

  sql_endpoint_id = module.reltio_sql_endpoint.id
  workspace       = module.workspace_vars.env
  additional_service_principal_permissions = [
    {
      service_principal_name = databricks_service_principal.reltio.application_id
      permission_level       = "CAN_USE"
    }
  ]
}
