# AWS Managed Policies

resource "aws_ssoadmin_managed_policy_attachment" "managed" {
  for_each = { for policy in local.managed_policy_maps : "${policy.ps_name}.${policy.policy_arn}" => policy }

  instance_arn       = tolist(data.aws_ssoadmin_instances.tarmac.arns)[0]
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.value.ps_name].arn
}

# Inline Policies

resource "aws_ssoadmin_permission_set_inline_policy" "inline" {
  for_each = { for ps_name, ps_attrs in var.permission_sets : ps_name => ps_attrs if can(ps_attrs.inline_policy) }

  inline_policy      = each.value.inline_policy
  instance_arn       = tolist(data.aws_ssoadmin_instances.tarmac.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.pset[each.key].arn
}