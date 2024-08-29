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
