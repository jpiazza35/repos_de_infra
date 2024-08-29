
resource "databricks_permissions" "job_usage" {
  job_id = var.job_id

  # hard coding roles until refactor
  access_control {
    permission_level = "CAN_MANAGE"
    group_name       = "${var.role_prefix}_admin"
  }

  access_control {
    permission_level = "CAN_MANAGE"
    group_name       = "${var.role_prefix}_engineer"
  }

  access_control {
    permission_level = "CAN_MANAGE_RUN"
    group_name       = "${var.role_prefix}_scientist"
  }

  access_control {
    permission_level = "CAN_VIEW"
    group_name       = "${var.role_prefix}_user"
  }

  #  access_control {
  #    permission_level = "CAN_VIEW"
  #    group_name       = "${var.role_prefix}_mpt_developers"
  #  }
}
