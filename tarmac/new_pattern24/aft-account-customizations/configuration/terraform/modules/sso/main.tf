resource "aws_ssoadmin_account_assignment" "sso" {
  for_each = {
    for sso in var.sso : sso.group => sso
  }
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso[0].arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.ps[each.key].arn

  principal_id   = data.aws_identitystore_group.grp[each.key].group_id
  principal_type = "GROUP"

  target_id   = var.account_id
  target_type = "AWS_ACCOUNT"
}
