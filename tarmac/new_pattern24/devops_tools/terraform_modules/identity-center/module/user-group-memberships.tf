resource "aws_identitystore_group_membership" "membership" {
  for_each = { for pair in local.group_membership : "${pair.user_name}.${pair.group_name}" => pair }

  identity_store_id = tolist(data.aws_ssoadmin_instances.tarmac.identity_store_ids)[0]
  group_id          = aws_identitystore_group.group[each.value.group_name].group_id
  member_id         = aws_identitystore_user.user[each.value.user_name].user_id
}