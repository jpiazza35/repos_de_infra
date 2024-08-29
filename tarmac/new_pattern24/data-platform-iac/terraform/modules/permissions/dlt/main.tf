locals {
  lower_environment = contains(["sdlc", "preview"], var.workspace)
}

resource "databricks_permissions" "dlt_permissions" {
  pipeline_id = var.pipeline_id

  access_control {
    permission_level = "CAN_VIEW"
    group_name       = "users"
  }

  #  dynamic "access_control" {
  #    for_each = var.owner_type == "service_principal" ? [""] : []
  #    content {
  #      permission_level       = "IS_OWNER"
  #      service_principal_name = var.owner_id
  #    }
  #  }
  #
  #  dynamic "access_control" {
  #    for_each = var.owner_type == "user" ? [""] : []
  #    content {
  #      permission_level = "IS_OWNER"
  #      user_name        = var.owner_id
  #    }
  #  }

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
