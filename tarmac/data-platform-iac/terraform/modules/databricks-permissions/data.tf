// Find all groups
data "databricks_group" "admins" {
  for_each = toset([
    for g in var.groups["admins"] : g
  ])
  display_name = each.value
}

data "databricks_group" "users" {
  for_each = toset([
    for g in var.groups["users"] : g
  ])
  display_name = each.value
}
