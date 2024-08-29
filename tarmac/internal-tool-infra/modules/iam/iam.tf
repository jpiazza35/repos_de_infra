resource "aws_iam_user" "user" {
  for_each = var.properties.iam_users
  name     = each.value.name
  path     = "/"
}

resource "aws_iam_group" "group" {
  for_each = toset(var.properties.iam_group)
  name     = each.value
}

resource "aws_iam_user_group_membership" "group_membership" {
  for_each = var.properties.iam_users
  groups   = each.value.group
  user     = each.value.name
}
