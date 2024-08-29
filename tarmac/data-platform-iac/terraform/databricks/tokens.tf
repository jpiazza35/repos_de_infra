locals {
  all_sp_map = merge({
    mpt    = databricks_service_principal.mpt
    bigeye = databricks_service_principal.bigeye
    }, local.deploy_dataworld ?
    {
      dataworld = databricks_service_principal.dataworld[0]
    } : {}
  )
}

module "token_permissions" {
  source                            = "../modules/token_policy"
  service_principal_application_ids = [for key, value in local.all_sp_map : value.application_id]
  user_group_names                  = [for role in ["engineer", "scientist", "user"] : "${module.workspace_vars.role_prefix}_${role}"]
}

module "tokens" {
  depends_on                       = [module.token_permissions]
  source                           = "../modules/service_principal_token"
  for_each                         = local.all_sp_map
  env                              = module.workspace_vars.env
  service_principal_application_id = each.value.application_id
  service_principal_name           = each.value.display_name
}
