
resource "databricks_permissions" "job_usage" {
  job_id = var.job_id

  access_control {
    permission_level = contains(["sdlc", "preview"], var.workspace) ? "CAN_MANAGE" : "CAN_VIEW"
    group_name       = "${local.role_prefixes[var.workspace]}_engineer"
  }

  access_control {
    permission_level = contains(["sdlc", "preview"], var.workspace) ? "CAN_MANAGE" : "CAN_VIEW"
    group_name       = "${local.role_prefixes[var.workspace]}_scientist"
  }

  access_control {
    permission_level = "CAN_VIEW"
    group_name       = "${local.role_prefixes[var.workspace]}_user"
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
