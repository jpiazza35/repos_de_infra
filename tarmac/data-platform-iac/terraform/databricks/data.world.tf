resource "databricks_service_principal" "dataworld" {
  count                      = module.workspace_vars.env == "prod" ? 1 : 0
  display_name               = "${module.workspace_vars.env}-dataworld-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_sql_endpoint" "dataworld" {
  count                = module.workspace_vars.env == "prod" ? 1 : 0
  cluster_size         = "2X-Small"
  name                 = "${module.workspace_vars.env}-dataworld-sql-endpoint"
  spot_instance_policy = "COST_OPTIMIZED"
  tags {
    dynamic "custom_tags" {
      for_each = local.tags
      content {
        key   = custom_tags.key
        value = custom_tags.value
      }
    }
  }
}

resource "databricks_permissions" "dataworld" {
  count           = module.workspace_vars.env == "prod" ? 1 : 0
  sql_endpoint_id = element(databricks_sql_endpoint.dataworld.*.id, count.index)

  access_control {
    service_principal_name = element(databricks_service_principal.dataworld.*.application_id, count.index)
    permission_level       = "CAN_USE"
  }

}
