resource "databricks_permissions" "repo_usage" {
  repo_id = var.role_prefix

  # hard coding roles until refactor
  access_control {
    permission_level = "CAN_EDIT"
    group_name       = "${var.role_prefix}_admin"
  }

  access_control {
    permission_level = "CAN_EDIT"
    group_name       = "${var.role_prefix}_engineer"
  }

  access_control {
    permission_level = "CAN_EDIT"
    group_name       = "${var.role_prefix}_scientist"
  }

  access_control {
    permission_level = "CAN_READ"
    group_name       = "${var.role_prefix}_user"
  }

  access_control {
    permission_level = "CAN_READ"
    group_name       = "${var.role_prefix}_mpt_developers"
  }
}
