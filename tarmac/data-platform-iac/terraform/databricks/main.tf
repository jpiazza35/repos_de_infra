locals {
  tags = {
    Team       = "Data Platform"
    Region     = "us-east-1"
    Project    = "data-platform-iac"
    Individual = "dwightwhitlock@cliniciannexus.com"
    Terraform  = true
  }
  default_spot_instance_policy = module.workspace_vars.env == "prod" ? "RELIABILITY_OPTIMIZED" : "COST_OPTIMIZED"
}


# force user to use terraform workspace, then have it configure the environment
module "workspace_vars" {
  source    = "../modules/workspace_variable_transformer"
  workspace = terraform.workspace
}

module "default_storage_credential" {
  source            = "../modules/storage_credential"
  env               = module.workspace_vars.env
  name              = "default"
  comment           = "Provides access to buckets in the the workspace AWS account."
  enable_self_trust = true
}

# need to add the following group permissions

locals {
  # should a principal (service principal, user or group) require catalog or schema level permissions, they should be added here
  # this maps between the tfvars and the actual principal id
  additional_group_lookups = {
    mpt_developers_group = var.mpt_developer_group_name
  }

  deploy_dataworld = module.workspace_vars.env == "prod" ? true : false

  principal_lookup = merge({
    mpt_sp       = databricks_service_principal.mpt.application_id
    bigeye_sp    = databricks_service_principal.bigeye.application_id
    rfi_sp       = databricks_service_principal.rfi.application_id
    dataworld_sp = local.deploy_dataworld ? databricks_service_principal.dataworld[0].application_id : null
  }, local.additional_group_lookups)
}

module "catalogs" {
  depends_on                   = [module.default_storage_credential]
  for_each                     = var.catalogs
  source                       = "../modules/catalog"
  catalog_name                 = each.key
  env                          = module.workspace_vars.env
  env_prefix                   = module.workspace_vars.env_prefix
  account_id                   = data.aws_caller_identity.current.account_id
  metastore_id                 = var.unity_catalog_metastore_id
  role_prefix                  = module.workspace_vars.role_prefix
  schemas                      = each.value.schemas
  schemas_get_isolated_buckets = each.value.schemas_get_isolated_buckets
  owner_service_principal_id   = data.databricks_current_user.terraform_sp.user_name

  # this isn't the cleanest, but it forces only one schema grant document to be created
  schema_grants    = each.value.schema_grants
  principal_lookup = local.principal_lookup


  storage_credential_iam_role = module.default_storage_credential.iam_role_name
  storage_credential_name     = module.default_storage_credential.storage_credential_name
  extra_catalog_grants = concat([
    {
      principal  = databricks_service_principal.bigeye.application_id
      privileges = ["USE_CATALOG", "SELECT", "USE_SCHEMA"]
    }],
    local.deploy_dataworld ? [
      {
        principal  = databricks_service_principal.dataworld[0].application_id
        privileges = ["USE_CATALOG", "SELECT", "USE_SCHEMA"]
      }
    ] : []
  )


}

resource "databricks_catalog_workspace_binding" "bindings" {
  # these are external to the workspace
  for_each     = var.linked_catalog_names
  catalog_name = each.value
  workspace_id = var.workspace_id
}
