resource "databricks_service_principal" "rfi" {
  display_name               = "${module.workspace_vars.env}-rfi-service-principal"
  allow_cluster_create       = true
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_access_control_rule_set" "rfi_rule" {
  name = "accounts/${var.databricks_account_id}/servicePrincipals/${databricks_service_principal.rfi.application_id}/ruleSets/default"

  grant_rules {
    principals = [data.databricks_current_user.terraform_sp.acl_principal_id]
    role       = "roles/servicePrincipal.user"
  }
}

resource "databricks_service_principal" "file_ingestion_sp" {
  display_name               = "${module.workspace_vars.env}-file-ingestion-service-principal"
  allow_cluster_create       = true
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_service_principal" "auditbook_etl_trigger" {
  display_name               = "${module.workspace_vars.env}-auditbook-etl-trigger-service-principal"
  allow_cluster_create       = true
  allow_instance_pool_create = false
  databricks_sql_access      = false
  workspace_access           = true
}

resource "databricks_service_principal" "auditbook_replicate_trigger" {
  display_name               = "${module.workspace_vars.env}-auditbook-replicate-trigger-service-principal"
  allow_cluster_create       = true
  allow_instance_pool_create = false
  databricks_sql_access      = false
  workspace_access           = true
}

resource "databricks_service_principal" "survey-data-workbench-sp" {
  display_name               = "${module.workspace_vars.env}-survey-data-workbench-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_service_principal" "benchmarks_sp" {
  display_name               = "${module.workspace_vars.env}-benchmarks-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_service_principal" "reltio" {
  display_name               = "${module.workspace_vars.env}-reltio-service-principal"
  allow_cluster_create       = true
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_service_principal" "data_quality" {
  display_name               = "${module.workspace_vars.env}-data-quality-service-principal"
  allow_cluster_create       = true
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_service_principal" "dataworld" {
  count                      = local.deploy_dataworld ? 1 : 0
  display_name               = "${module.workspace_vars.env}-dataworld-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

resource "databricks_service_principal" "pna" {
  display_name               = "${module.workspace_vars.env}-pna-service-principal"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}

locals {
  all_sp_map = merge({
    mpt                         = databricks_service_principal.mpt
    ingestion                   = databricks_service_principal.file_ingestion_sp
    bigeye                      = databricks_service_principal.bigeye
    auditbook_etl_trigger       = databricks_service_principal.auditbook_etl_trigger
    auditbook_replicate_trigger = databricks_service_principal.auditbook_replicate_trigger
    dwb_sp                      = databricks_service_principal.survey-data-workbench-sp
    benchmarks_sp               = databricks_service_principal.benchmarks_sp
    reltio_sp                   = databricks_service_principal.reltio
    dq_sp                       = databricks_service_principal.data_quality
    pna                         = databricks_service_principal.pna
    }, local.deploy_dataworld ?
    {
      dataworld = databricks_service_principal.dataworld[0]
    } : {}
  )
}

module "token_permissions" {
  source                            = "../modules/token_policy"
  service_principal_application_ids = [for key, value in local.all_sp_map : value.application_id]
  user_group_names                  = concat([for role in ["engineer", "scientist"] : "${module.workspace_vars.role_prefix}_${role}"], var.enable_token_use_group_names)
}

module "tokens" {
  depends_on                       = [module.token_permissions]
  source                           = "../modules/service_principal_token"
  for_each                         = local.all_sp_map
  env                              = module.workspace_vars.env
  service_principal_application_id = each.value.application_id
  service_principal_name           = each.value.display_name
}
