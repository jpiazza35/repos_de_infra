locals {
  env_map = {
    dev     = "dev"  # data platform lower environment
    sdlc    = "sdlc" # databricks lower environmnent
    prod    = "prod"
    preview = "preview"
  }

  # this is not always consistent across all groups because another team owns AD group provisioning
  # and every time there is an update, something is miscommunicated. When this happens, just create a new
  # variable specifically for the group like var.mpt_developer_group_name
  role_prefix_map = {
    dev     = null
    sdlc    = "db_sdlc"
    prod    = "db_prod_ws"
    preview = "db_preview"
  }
  env_prefix = {
    dev     = null
    sdlc    = "d"
    prod    = "p"
    preview = "s"
  }
  aws_databricks_profile = {
    dev     = null
    sdlc    = "ss_databricks"
    preview = "s_databricks"
    prod    = "p_databricks"
  }
  aws_data_platform_profile = {
    dev     = "d_data_platform"
    sdlc    = "d_data_platform"
    prod    = "p_data_platform"
    preview = "s_data_platform"
  }
  databricks_profile = {
    dev     = null
    sdlc    = "tf_sdlc"
    prod    = "tf_prod"
    preview = "tf_preview"
  }
}

output "env" {
  value = local.env_map[var.workspace]
}

output "env_prefix" {
  description = "This is used for the databricks catalog names, like p_source_oriented"
  value       = local.env_prefix[var.workspace]
}

output "role_prefix" {
  value = local.role_prefix_map[var.workspace]
}

output "aws_profile_databricks" {
  value = local.aws_databricks_profile[var.workspace]
}

output "aws_profile_data_platform" {
  value = local.aws_data_platform_profile[var.workspace]
}

output "databricks_profile" {
  value = local.databricks_profile[var.workspace]
}
