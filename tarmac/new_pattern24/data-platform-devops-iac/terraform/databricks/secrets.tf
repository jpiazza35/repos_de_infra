resource "vault_generic_secret" "sp" {
  path = var.env == "prod" ? "data_platform/${var.env}/databricks/service-principal-tokens" : "data_platform/dev/databricks/service-principal-tokens"

  data_json = <<EOT
{
  "${module.databricks_workspaces.service_account_credentials["sp_name"]}": "${module.databricks_workspaces.service_account_credentials["sp_token"]}"
}
EOT
}
