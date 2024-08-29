data "aws_caller_identity" "current" {}



data "databricks_spark_version" "latest" {
  latest = true
}

data "databricks_node_type" "node" {
  min_memory_gb = 16
}

data "databricks_current_user" "terraform_sp" {}

data "aws_iam_role" "cross_account_role" {
  name = "${module.workspace_vars.env}-databricks-crossaccount"
}

data "databricks_group" "data_engineers" {
  display_name = "${module.workspace_vars.role_prefix}_engineer"
}
