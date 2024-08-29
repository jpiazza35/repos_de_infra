module "bigeye_agents" {
  for_each = var.agent_to_vault_secret_map

  source                   = "../modules/bigeye_agent"
  agent_identifier         = "${each.key}-${module.workspace_vars.env}"
  agent_config_secret_name = each.value
  mtls_secret_name         = var.bigeye_mtls_secret_name
  env                      = var.env
}

# this is only set up for prod at the moment
module "workspace_vars" {
  source    = "../modules/workspace_variable_transformer"
  workspace = terraform.workspace
}
