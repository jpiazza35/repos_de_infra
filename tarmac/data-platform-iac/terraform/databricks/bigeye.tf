resource "databricks_service_principal" "bigeye" {
  display_name               = "${module.workspace_vars.env}-bigeye-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_sql_endpoint" "bigeye" {
  cluster_size         = var.bigeye_cluster_size
  name                 = "${module.workspace_vars.env}-bigeye-sql-endpoint"
  spot_instance_policy = local.default_spot_instance_policy
  warehouse_type       = "PRO"

  tags {
    dynamic "custom_tags" {
      for_each = local.tags
      content {
        key   = custom_tags.key
        value = custom_tags.value
      }
    }
  }
}

resource "databricks_permissions" "bigeye" {
  sql_endpoint_id = databricks_sql_endpoint.bigeye.id

  access_control {
    service_principal_name = databricks_service_principal.bigeye.application_id
    permission_level       = "CAN_USE"
  }

}

locals {
  httpPath = regex("httpPath=([^;]+)", databricks_sql_endpoint.bigeye.jdbc_url)[0]

  # strip https:// from the workspace url
  workspace_host = substr(data.databricks_current_user.terraform_sp.workspace_url, 8, -1)
}

resource "vault_generic_secret" "bigeye-creds" {
  data_json = jsonencode({
    databaseName = ""
    host         = local.workspace_host
    password     = module.tokens["bigeye"].token
    port         = ""
    username     = local.httpPath
  })
  path = "data_platform/${module.workspace_vars.env}/bigeye/databricks"
}
