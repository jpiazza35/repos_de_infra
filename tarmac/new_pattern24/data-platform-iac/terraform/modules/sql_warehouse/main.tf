module "workspace_vars" {
  source    = "../workspace_variable_transformer"
  workspace = terraform.workspace
}

locals {
  is_serverless = var.warehouse_type == "PRO" && var.enable_serverless_compute == true ? true : false
}

resource "databricks_sql_endpoint" "this" {
  cluster_size              = var.cluster_size
  name                      = "${module.workspace_vars.env}-${var.name}"
  min_num_clusters          = var.min_num_clusters
  max_num_clusters          = var.max_num_clusters
  auto_stop_mins            = local.is_serverless == true && var.auto_stop_mins != 0 ? 15 : var.auto_stop_mins
  spot_instance_policy      = var.spot_instance_policy
  warehouse_type            = var.warehouse_type
  enable_serverless_compute = local.is_serverless

  tags {
    dynamic "custom_tags" {
      for_each = var.tags
      content {
        key   = custom_tags.key
        value = custom_tags.value
      }
    }
  }
}

module "vault_secret" {
  count           = var.create_vault_secret == true ? 1 : 0
  source          = "../sql_endpoint_vault"
  environment     = terraform.workspace
  sql_endpoint_id = databricks_sql_endpoint.this.id
}