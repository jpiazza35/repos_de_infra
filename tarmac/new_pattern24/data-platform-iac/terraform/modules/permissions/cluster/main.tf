locals {
  lower_environment = contains(["sdlc", "preview"], var.workspace)
  has_access_control = anytrue([
    local.lower_environment,
    length(var.additional_group_permissions) != 0 ? true : false,
    length(var.additional_service_principal_permissions) != 0 ? true : false
  ])
}

resource "databricks_permissions" "cluster_usage" {
  count      = local.has_access_control ? 1 : 0
  cluster_id = var.cluster_id

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

}
