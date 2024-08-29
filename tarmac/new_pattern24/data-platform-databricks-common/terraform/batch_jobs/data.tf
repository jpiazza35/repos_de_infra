locals {
  secret_prefix = "data_platform/${module.workspace_vars.env}"
}

data "vault_generic_secret" "databricks-ces" {
  path = "${local.secret_prefix}/databricks/ces"
}

data "vault_generic_secret" "databricks-sql" {
  path = "${local.secret_prefix}/databricks/sql_server"
}

data "vault_generic_secret" "sql_server_prod" {
  # only need to create separate "prod" credentials for the sdlc benchmark job
  count = terraform.workspace == "sdlc" ? 1 : 0
  path  = "data_platform/prod/databricks/sql_server"
}