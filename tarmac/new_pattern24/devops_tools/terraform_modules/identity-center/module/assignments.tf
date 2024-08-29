### Permissions assignments ###

resource "aws_ssoadmin_account_assignment" "assignment" {
  for_each = { for assignment in local.account_assignments : "${assignment.principal_name}.${assignment.permission_set.name}.${assignment.account_id}" => assignment }

  instance_arn       = each.value.permission_set.instance_arn
  permission_set_arn = each.value.permission_set.arn

  principal_id   = aws_identitystore_group.group[each.value.principal_name].group_id
  principal_type = each.value.principal_type

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}
