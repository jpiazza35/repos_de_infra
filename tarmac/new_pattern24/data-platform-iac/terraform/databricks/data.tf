data "aws_caller_identity" "current" {}

data "databricks_spark_version" "latest" {
  latest = true
}

data "databricks_node_type" "node" {
  min_memory_gb = 16
}

data "databricks_node_type" "smallest" {
  local_disk = true
}


data "databricks_spark_version" "spark_scala" {
  latest = true
}

data "databricks_current_user" "terraform_sp" {}

data "aws_iam_role" "cross_account_role" {
  name = "${module.workspace_vars.env}-databricks-crossaccount"
}

data "databricks_group" "data_engineers" {
  display_name = "${module.workspace_vars.role_prefix}_engineer"
}

## Fivetran
data "vault_generic_secret" "ces_credentials" {
  path = "data_platform/${module.workspace_vars.env}/fivetran/ces_database_credentials"
}

data "vault_generic_secret" "benchmark_credentials" {
  path = "data_platform/${module.workspace_vars.env}/fivetran/rds_sql_server_credentials"
}

data "vault_generic_secret" "fivetran_service_account" {
  path = "data_platform/${module.workspace_vars.env}/fivetran/databricks_service_account"
}
