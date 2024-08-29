resource "databricks_service_principal" "mpt" {
  display_name               = "${module.workspace_vars.env}-mpt-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

module "mpt_sql_endpoint" {
  source = "../modules/sql_warehouse"
  name   = "mpt-sql-endpoint"
  tags   = local.tags
}

module "mpt_warehouse_permission" {
  source          = "../modules/permissions/sql_warehouse"
  workspace       = terraform.workspace
  sql_endpoint_id = module.mpt_sql_endpoint.id
  additional_service_principal_permissions = [{
    service_principal_name = databricks_service_principal.mpt.application_id
    permission_level       = "CAN_USE"
  }]
}
