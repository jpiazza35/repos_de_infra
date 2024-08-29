data "aws_ssoadmin_instances" "sso" {
  count = var.sso != {} ? 1 : 0
}

data "aws_ssoadmin_permission_set" "ps" {
  for_each = {
    for sso in var.sso : sso.group => sso
  }
  instance_arn = tolist(data.aws_ssoadmin_instances.sso[0].arns)[0]
  name         = each.value.role
}

data "aws_identitystore_group" "grp" {
  for_each = {
    for sso in var.sso : sso.group => sso
  }
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso[0].identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value.group
    }
  }
}

data "aws_caller_identity" "current" {
  count = var.sso != {} ? 1 : 0
}
