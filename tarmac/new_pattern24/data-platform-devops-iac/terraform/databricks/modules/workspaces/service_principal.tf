resource "databricks_service_principal" "admin" {
  provider     = databricks.mws
  display_name = format("%s-admin-sp", local.prefix)
}

resource "databricks_service_principal_secret" "admin" {
  provider             = databricks.mws
  service_principal_id = databricks_service_principal.admin.id
}

# provider "databricks" {}