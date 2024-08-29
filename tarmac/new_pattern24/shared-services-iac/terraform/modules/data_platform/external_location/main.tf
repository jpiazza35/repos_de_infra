resource "databricks_storage_credential" "external" {
  name = aws_iam_role.external_data_access.name
  aws_iam_role {
    role_arn = aws_iam_role.external_data_access.arn
  }
}

resource "databricks_external_location" "location" {
  name            = "${var.databricks_workspace_name}-${var.prefix}-${var.external_storage_label}-${var.external_storage_location_label}"
  url             = "s3://${var.databricks_workspace_name}-${var.prefix}-${var.external_storage_label}/${var.external_storage_location_label}"
  credential_name = databricks_storage_credential.external.id
}

resource "databricks_grants" "external_storage_credential" {
  storage_credential = databricks_storage_credential.external.id
  dynamic "grant" {
    for_each = var.external_storage_admins_display_name
    content {
      principal  = grant.value
      privileges = var.external_storage_privileges
    }

  }
}

resource "databricks_grants" "external_storage" {
  external_location = databricks_external_location.location.id
  dynamic "grant" {
    for_each = var.external_storage_admins_display_name
    content {
      principal  = grant.value
      privileges = var.external_storage_privileges
    }
  }

}
