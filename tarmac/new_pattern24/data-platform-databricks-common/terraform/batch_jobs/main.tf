module "workspace_vars" {
  source    = "git::https://github.com/clinician-nexus/data-platform-iac//terraform/modules/workspace_variable_transformer"
  workspace = terraform.workspace
}

module "batch_jobs" {
  for_each             = var.batch_jobs
  source               = "../modules/batch_ingestion_job"
  env                  = module.workspace_vars.env
  role_prefix          = module.workspace_vars.role_prefix
  source_name          = each.key
  cron_schedule_enable = true
  named_parameters = {
    secret_scope      = databricks_secret_scope.jdbc.name,
    username_secret   = each.value.username_secret,
    password_secret   = each.value.password_secret,
    database_product  = each.value.database_product,
    host_name_secret  = each.value.host_name_secret,
    port_number       = each.value.port_number,
    database_name     = each.value.database_name,
    target_schema     = each.key,
    target_table_list = jsonencode(each.value.target_table_list),
    target_catalog    = var.target_catalog,
    num_partitions    = 8,
  }
  wheel_path           = var.wheel_path
  instance_profile_arn = var.instance_profile_arn
  default_role_prefix  = module.workspace_vars.role_prefix
}

resource "databricks_secret_scope" "jdbc" {
  name = "jdbc"
}

locals {
  ces_secret_keys            = toset(["ces-hostname", "ces-username", "ces-password"])
  sqlserver_server_keys      = toset(["sqlserver-hostname", "sqlserver-username", "sqlserver-password"])
  prod_sqlserver_server_keys = toset(["prod-sqlserver-hostname", "prod-sqlserver-username", "prod-sqlserver-password"])
}

resource "databricks_secret" "ces_secret" {
  for_each     = local.ces_secret_keys
  key          = each.key
  string_value = data.vault_generic_secret.databricks-ces.data[each.key]
  scope        = databricks_secret_scope.jdbc.id
}

resource "databricks_secret" "sql_secret" {
  for_each     = local.sqlserver_server_keys
  key          = each.key
  string_value = data.vault_generic_secret.databricks-sql.data[each.key]
  scope        = databricks_secret_scope.jdbc.id
}

resource "databricks_secret" "sql_prod_secret" {
  for_each = terraform.workspace == "sdlc" ? local.prod_sqlserver_server_keys : toset([])
  key      = each.key
  scope    = databricks_secret_scope.jdbc.id

  # hacky, but don't want to make another vault entry
  string_value = data.vault_generic_secret.sql_server_prod[0].data[substr(each.key, 5, -1)]
}
