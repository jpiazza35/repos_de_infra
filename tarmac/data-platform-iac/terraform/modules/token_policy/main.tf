resource "databricks_permissions" "token_usage" {
  authorization = "tokens"

  dynamic "access_control" {
    for_each = var.service_principal_application_ids
    content {
      service_principal_name = access_control.value
      permission_level       = "CAN_USE"
    }
  }

  dynamic "access_control" {
    for_each = var.user_group_names
    content {
      group_name       = access_control.value
      permission_level = "CAN_USE"
    }
  }
}

resource "time_sleep" "policy_propagation" {
  depends_on       = [databricks_permissions.token_usage]
  create_duration  = "30s"
  destroy_duration = "30s"
}
