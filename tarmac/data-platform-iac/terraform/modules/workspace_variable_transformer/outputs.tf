locals {
  env_map = {
    sdlc = "sdlc"
    prod = "prod"
  }

  # this is not always consistent across all groups because another team owns AD group provisioning
  # and every time there is an update, something is miscommunicated. When this happens, just create a new
  # variable specifically for the group like var.mpt_developer_group_name
  role_prefix_map = {
    sdlc = "db_sdlc"
    prod = "db_prod_ws"
  }
  env_prefix = {
    sdlc = "d"
    prod = "p"
  }
  aws_databricks_profile = {
    sdlc = "ss_databricks"
    prod = "p_databricks"
  }
  aws_data_platform_profile = {
    sdlc = "d_data_platform"
    prod = "p_data_platform"
  }
  databricks_profile = {
    sdlc = "tf_sdlc"
    prod = "tf_prod"
  }
}

output "env" {
  value = local.env_map[var.workspace]
}

output "env_prefix" {
  value = local.env_prefix[var.workspace]
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
