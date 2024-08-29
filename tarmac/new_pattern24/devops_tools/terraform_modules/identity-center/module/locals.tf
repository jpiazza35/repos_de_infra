locals {
  managed_policies = { for ps_name, ps_attrs in var.permission_sets : ps_name => ps_attrs if can(ps_attrs.managed_policy) }
  managed_policy_maps = flatten([
    for ps_name, ps_attrs in local.managed_policies : {
      ps_name    = ps_name
      policy_arn = ps_attrs.managed_policy
    } if can(ps_attrs.managed_policy)
  ])

  account_assignments = flatten([
    for group in var.account_assignments : {
      principal_name = group.principal_name
      principal_type = group.principal_type
      permission_set = aws_ssoadmin_permission_set.pset[group.permission_set]
      account_id     = group.account_id
    }
  ])

  groups = [for group in var.account_assignments : group.principal_name]

  group_membership = flatten([
    for user_name, user_attr in var.sso_users : [
      for group_name in user_attr.sso_groups : {
        user_name  = user_name
        group_name = group_name
      }
    ]
  ])

  sso_users = flatten([
    for user in var.sso_users : [
      for group in user.sso_groups : {
        user_name    = user.user_name
        display_name = user.display_name
        given_name   = user.given_name
        family_name  = user.family_name
        group        = group
      }
    ]
  ])
}