locals {
  lower_environment = contains(["sdlc", "preview"], var.workspace)
}

resource "databricks_permissions" "sql" {
  sql_endpoint_id = var.sql_endpoint_id


  dynamic "access_control" {
    for_each = local.lower_environment ? ["engineer", "scientist"] : []
    content {
      permission_level = "CAN_MANAGE"
      group_name       = "${local.role_prefixes[var.workspace]}_${access_control.value}"
    }
  }

  dynamic "access_control" {
    for_each = var.additional_group_permissions
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }

  dynamic "access_control" {
    for_each = var.additional_service_principal_permissions
    content {
      service_principal_name = access_control.value.service_principal_name
      permission_level       = access_control.value.permission_level
    }
  }

  dynamic "access_control" {
    for_each = var.additional_user_permissions
    content {
      user_name        = access_control.value.user_name
      permission_level = access_control.value.permission_level
    }
  }

}
