resource "databricks_entitlements" "workspace-admin" {
  for_each                   = data.databricks_group.admins
  group_id                   = each.value.display_name
  allow_cluster_create       = true
  allow_instance_pool_create = true
  databricks_sql_access      = true
  workspace_access           = true
}

#resource "databricks_entitlements" "workspace-users" {
#  for_each                   = data.databricks_group.users
#  group_id                   = each.value.display_name
#  allow_cluster_create       = false
#  allow_instance_pool_create = false
#  databricks_sql_access      = false
#  workspace_access           = true
#}
