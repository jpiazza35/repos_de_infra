data "databricks_sql_warehouse" "this" {
  id = var.sql_endpoint_id
}
