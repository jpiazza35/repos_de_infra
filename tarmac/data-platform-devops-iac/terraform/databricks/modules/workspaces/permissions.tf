resource "time_sleep" "workspace_provisioning_wait" {
  ## The metastore needs about 10 minutes of buffer time before permission assignments

  create_duration = "10m"

  triggers = {
    workspace_id = databricks_mws_workspaces.workspace.workspace_id
  }

}

// You can only create a single metastore for each region in which your organization operates, and attach workspaces to the metastore. Each workspace will have the same view of the data you manage in Unity Catalog.
resource "databricks_metastore_assignment" "metastore" {

  provider     = databricks.created_workspace
  metastore_id = "536be71c-5fe1-43df-b3cb-6230d1949f89" #"aws-us-east-1-uc" #databricks_metastore.metastore.id
  workspace_id = databricks_mws_workspaces.workspace.workspace_id
  depends_on = [
    time_sleep.workspace_provisioning_wait
  ]
}

resource "databricks_mws_permission_assignment" "add_admin_group" {
  for_each     = data.databricks_group.admins
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.workspace.workspace_id
  principal_id = each.value.id
  permissions = [
    "ADMIN"
  ]
  depends_on = [
    databricks_metastore_assignment.metastore
  ]
}

resource "databricks_mws_permission_assignment" "add_user_group" {
  for_each     = data.databricks_group.users
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.workspace.workspace_id
  principal_id = each.value.id
  permissions = [
    "USER"
  ]
  depends_on = [
    databricks_metastore_assignment.metastore
  ]
}

resource "databricks_entitlements" "technical_users" {
  for_each = data.databricks_group.technical_users
  group_id = each.value.id

  # default provider -> account level
  allow_cluster_create       = true
  allow_instance_pool_create = false
}

resource "databricks_mws_permission_assignment" "sp_add_admin_group" {
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.workspace.workspace_id
  principal_id = databricks_service_principal.admin.id
  permissions  = ["ADMIN"]
  depends_on = [
    databricks_metastore_assignment.metastore
  ]
}
