
# need a list of tuples that are (environment, repository)
locals {
  set_product = setproduct(var.repositories, keys(var.environments))
  sp_map      = { for i in local.set_product : "${i[0]}-${i[1]}" => i }
}

module "databricks_environment" {
  for_each                      = local.sp_map
  source                        = "../modules/databricks_github_environment"
  env                           = each.value[1]
  repository                    = each.value[0]
  databricks_aws_account_number = var.environments[each.value[1]].account_number
}
