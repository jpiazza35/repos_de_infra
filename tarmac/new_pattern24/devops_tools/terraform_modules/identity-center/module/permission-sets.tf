# All permission sets.

resource "aws_ssoadmin_permission_set" "pset" {
  for_each = var.permission_sets

  name             = each.key
  description      = each.value.description
  instance_arn     = tolist(data.aws_ssoadmin_instances.tarmac.arns)[0]
  session_duration = each.value.session_duration

  tags = var.tags
}