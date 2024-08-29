resource "databricks_catalog" "this" {
  # properties attribute does not propagate to tags
  metastore_id   = var.metastore_id
  name           = "${var.catalog_prefix}${var.catalog_name}"
  provider_name  = var.provider_name
  share_name     = var.share_name
  comment        = var.comment
  isolation_mode = var.isolation_mode
  force_destroy  = false
}

resource "databricks_grants" "catalog_grants" {
  catalog = databricks_catalog.this.name

  # engineers have special privileges for troubleshooting
  # todo: extract this somewhere else
  grant {
    principal  = "${var.role_prefix}_engineer"
    privileges = ["EXECUTE", "READ_VOLUME", "SELECT", "USE_CATALOG", "USE_SCHEMA"]
  }

  # all users can see all catalogs and schemas. doesn't mean they can select from tables
  # system group "user" can't be granted catalog access. this is managed in AD, and expected
  # behavior is that all human members of a databricks group are in here
  grant {
    principal  = "${var.role_prefix}_user"
    privileges = ["USE_CATALOG", "USE_SCHEMA"]
  }

  grant {
    principal  = "${var.role_prefix}_admin"
    privileges = ["EXECUTE", "MODIFY", "READ_VOLUME", "SELECT", "USE_CATALOG", "USE_SCHEMA"]
  }

  dynamic "grant" {
    for_each = var.catalog_grants
    content {
      principal  = var.principal_lookup[grant.value.principal]
      privileges = setsubtract(grant.value.privileges, local.delta_share_unallowed_privileges)
    }
  }

}

locals {
  all_catalog_principals = [
    for grant in var.catalog_grants : grant.principal
  ]
  unique_catalog_principals = distinct(local.all_catalog_principals)
  delta_share_unallowed_privileges = [
    "ALL_PRIVILEGES",
    "CREATE_FUNCTION",
    "CREATE_MATERIALIZED_VIEW",
    "CREATE_MODEL",
    "CREATE_SCHEMA",
    "CREATE_TABLE",
    "CREATE_VOLUME",
    "WRITE_VOLUME",
    "MODIFY"
  ]
}

resource "time_sleep" "catalog_grant" {
  depends_on      = [databricks_grants.catalog_grants]
  create_duration = "5s"
}