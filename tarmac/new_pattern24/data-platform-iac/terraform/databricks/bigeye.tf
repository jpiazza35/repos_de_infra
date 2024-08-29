locals {
  deploy_bigeye = module.workspace_vars.env == "prod" || module.workspace_vars.env == "preview" ? true : false
  httpPath      = module.workspace_vars.env == "prod" || module.workspace_vars.env == "preview" ? regex("httpPath=([^;]+)", module.bigeye_sql_endpoint[0].jdbc_url)[0] : ""

  # strip https:// from the workspace url
  workspace_host = substr(data.databricks_current_user.terraform_sp.workspace_url, 8, -1)
}

resource "databricks_service_principal" "bigeye" {
  display_name               = "${module.workspace_vars.env}-bigeye-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

module "bigeye_sql_endpoint" {
  count  = local.deploy_bigeye ? 1 : 0
  source = "../modules/sql_warehouse"
  name   = "bigeye-sql-endpoint"
  tags   = local.tags
}


module "bigeye_sql_endpoint_permission" {
  count           = local.deploy_bigeye ? 1 : 0
  source          = "../modules/permissions/sql_warehouse"
  workspace       = terraform.workspace
  sql_endpoint_id = module.bigeye_sql_endpoint[0].id

  additional_service_principal_permissions = [{
    service_principal_name = databricks_service_principal.bigeye.application_id
    permission_level       = "CAN_USE"
  }]
}

# DEPRECATED: update any dependent uses to dwb_sql_endpoint vault_path
resource "vault_generic_secret" "bigeye-creds" {
  count = local.deploy_bigeye ? 1 : 0
  data_json = jsonencode({
    databaseName = ""
    host         = local.workspace_host
    password     = module.tokens["bigeye"].token
    port         = ""
    username     = local.httpPath
  })
  path = "data_platform/${module.workspace_vars.env}/bigeye/databricks"
}
