output "id" {
  value = databricks_sql_endpoint.this.id
}

output "jdbc_url" {
  value = databricks_sql_endpoint.this.jdbc_url
}

output "odbc_params" {
  value = databricks_sql_endpoint.this.odbc_params
}

output "data_source_id" {
  value = databricks_sql_endpoint.this.data_source_id
}

output "vault_path" {
  value = var.create_vault_secret == true ? module.vault_secret[0].path : ""
}
