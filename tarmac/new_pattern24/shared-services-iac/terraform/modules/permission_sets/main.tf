resource "aws_ssoadmin_permission_set" "management_permission_sets" {
  for_each = {
    for p in var.permission_sets : p.name => p
  }
  name             = each.value.name
  instance_arn     = data.aws_ssoadmin_instances.mgmt.arns[0]
  session_duration = var.session_duration
  description      = each.value.description
  tags = {
    Name        = each.key
    Environment = "sharedservices"
    App         = "IAM"
    Resource    = "Managed by Terraform"
    Description = "IAM/SSO Related Configuration"
    Team        = "Devops"
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline" {
  for_each = {
    for p in var.permissions : p.name => p
    if p.inline_policies != []
  }
  inline_policy      = each.value.inline_policies[0]
  instance_arn       = data.aws_ssoadmin_instances.mgmt.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.management_permission_sets[each.key].arn
}

resource "aws_ssoadmin_managed_policy_attachment" "managed" {
  for_each = {
    for p in local.managed_policies : "${p.name}-${replace(p.mp, "/.*//", "")}" => {
      mp   = p.mp
      name = p.name
    }
  }

  managed_policy_arn = each.value.mp
  instance_arn       = data.aws_ssoadmin_instances.mgmt.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.management_permission_sets[each.value.name].arn
}
