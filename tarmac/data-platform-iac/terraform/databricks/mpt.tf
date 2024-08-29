resource "databricks_service_principal" "mpt" {
  display_name               = "${module.workspace_vars.env}-mpt-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}


resource "databricks_sql_endpoint" "mpt" {
  cluster_size              = var.mpt_endpoint.cluster_size
  name                      = "mpt-sql-endpoint"
  min_num_clusters          = var.mpt_endpoint.min_num_clusters
  max_num_clusters          = var.mpt_endpoint.max_num_clusters
  auto_stop_mins            = 0
  spot_instance_policy      = "RELIABILITY_OPTIMIZED"
  enable_serverless_compute = false
  warehouse_type            = "CLASSIC"

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


resource "databricks_permissions" "endpoint_mpt" {
  sql_endpoint_id = databricks_sql_endpoint.mpt.id

  access_control {
    service_principal_name = databricks_service_principal.mpt.application_id
    permission_level       = "CAN_USE"
  }
}
