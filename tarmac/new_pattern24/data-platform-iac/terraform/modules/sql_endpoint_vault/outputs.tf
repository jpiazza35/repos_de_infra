output "path" {
  value = "${local.devops_vault_base_path[var.environment]}/databricks/sql_endpoints/${data.databricks_sql_warehouse.this.name}"
}