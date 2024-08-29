locals {
  devops_vault_base_path = {
    prod    = "prod"
    preview = "prod/preview"
    dev     = "dev"
    qa      = "qa"
    sdlc    = "dev"
  }
}

resource "vault_generic_secret" "this" {
  data_json = jsonencode({
    id          = data.databricks_sql_warehouse.this.id
    jdbc_url    = data.databricks_sql_warehouse.this.jdbc_url
    name        = data.databricks_sql_warehouse.this.name
    odbc_params = data.databricks_sql_warehouse.this.odbc_params
  })
  path = "${local.devops_vault_base_path[var.environment]}/databricks/sql_endpoints/${data.databricks_sql_warehouse.this.name}"
}
