module "pna_sql_endpoint" {
  source       = "../modules/sql_warehouse"
  name         = "pna-sql-endpoint"
  cluster_size = var.pna_sql_endpoint_size
  tags         = local.tags
}


module "pna_external_location" {
  source                      = "../modules/external_location"
  name                        = "pna_${local.external_location_qualifier[terraform.workspace]}_external_location"
  s3_bucket                   = var.pna_bucket
  create_bucket               = false
  role_prefix                 = module.workspace_vars.role_prefix
  storage_credential_iam_role = module.default_storage_credential.iam_role_name
  storage_credential_name     = module.default_storage_credential.storage_credential_name
  permission_mode             = "READ_ONLY"
}


module "pna_warehouse_permission" {
  source          = "../modules/permissions/sql_warehouse"
  workspace       = terraform.workspace
  sql_endpoint_id = module.pna_sql_endpoint.id
  additional_service_principal_permissions = [{
    service_principal_name = databricks_service_principal.pna.application_id
    permission_level       = "CAN_USE"
  }]
}
