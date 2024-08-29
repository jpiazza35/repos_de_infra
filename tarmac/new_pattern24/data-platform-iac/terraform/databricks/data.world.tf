resource "databricks_cluster" "dataworld" {
  count                   = local.deploy_dataworld ? 1 : 0
  cluster_name            = "dataworld-cluster"
  spark_version           = "13.3.x-scala2.12"
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  data_security_mode      = "SINGLE_USER"
  single_user_name        = databricks_service_principal.dataworld[0].application_id
  autoscale {
    min_workers = 1
    max_workers = 3
  }
}

module "ddw_cluster_permissions" {
  count      = local.deploy_dataworld ? 1 : 0
  source     = "../modules/permissions/cluster"
  cluster_id = databricks_cluster.dataworld[0].id
  workspace  = module.workspace_vars.env

  additional_service_principal_permissions = [
    {
      permission_level       = "CAN_RESTART"
      service_principal_name = databricks_service_principal.dataworld[0].application_id
    }
  ]
}
