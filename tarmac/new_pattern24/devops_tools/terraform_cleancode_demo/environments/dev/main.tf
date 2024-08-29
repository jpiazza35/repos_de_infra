module "networking" {
  for_each = var.vpc_args
  source   = "../../modules/networking"

  args = merge(var.global_args, each.value, { name = each.key })
}

module "data" {
  for_each = var.dynamodb_args
  source   = "../../modules/data"

  args = merge(var.global_args, each.value, { name = each.key })
}