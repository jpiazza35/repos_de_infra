
module "external_location" {
  source                      = "../external_location"
  name                        = "${var.env_prefix}-${var.catalog_name}"
  role_prefix                 = var.role_prefix
  storage_credential_iam_role = var.storage_credential_iam_role
  storage_credential_name     = var.storage_credential_name
  account_id                  = var.account_id
}


locals {
  prefixed_catalog_name = "${var.env_prefix}_${var.catalog_name}"
  storage_root          = "s3://${module.external_location.bucket_name}/"
}


resource "databricks_catalog" "this" {
  # properties attribute does not propagate to tags
  depends_on     = [module.external_location]
  metastore_id   = var.metastore_id
  name           = local.prefixed_catalog_name
  comment        = var.comment
  isolation_mode = "ISOLATED"
  storage_root   = local.storage_root
  force_destroy  = false
}


module "schema_external_locations" {
  source                      = "../external_location"
  for_each                    = var.schemas_get_isolated_buckets ? toset(var.schemas) : toset([])
  name                        = "${var.env_prefix}-${var.catalog_name}-${each.value}"
  role_prefix                 = var.role_prefix
  storage_credential_iam_role = var.storage_credential_iam_role
  storage_credential_name     = var.storage_credential_name
  account_id                  = var.account_id

}




resource "databricks_grants" "catalog_grants" {
  catalog = databricks_catalog.this.name

  grant {
    principal  = "${var.role_prefix}_engineer"
    privileges = ["CREATE_FUNCTION", "CREATE_SCHEMA", "CREATE_TABLE", "CREATE_VOLUME", "MODIFY", "SELECT", "USE_CATALOG", "USE_SCHEMA", "WRITE_VOLUME", "READ_VOLUME"]
  }

  grant {
    principal  = "${var.role_prefix}_user"
    privileges = ["USE_CATALOG"]
  }

  grant {
    principal  = "${var.role_prefix}_scientist"
    privileges = ["USE_CATALOG", "USE_SCHEMA"]
  }

  grant {
    principal  = "${var.role_prefix}_admin"
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = var.owner_service_principal_id
    privileges = ["USE_CATALOG", "CREATE_SCHEMA", "USE_SCHEMA"]
  }

  dynamic "grant" {
    for_each = var.extra_catalog_grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  # any principal that has a grant on a catalog's schema should get USE_CATALOG
  dynamic "grant" {
    for_each = local.unique_schema_principals
    content {
      principal  = var.principal_lookup[grant.value]
      privileges = ["USE_CATALOG"]
    }
  }
}

locals {
  all_schema_principals = [
    for schema in var.schema_grants : [
      for grant in schema : grant.principal
    ]
  ]
  unique_schema_principals = distinct(flatten(local.all_schema_principals))
}

resource "time_sleep" "catalog_grant" {
  depends_on      = [databricks_grants.catalog_grants]
  create_duration = "5s"
}

resource "databricks_schema" "schemas" {
  depends_on    = [databricks_catalog.this, databricks_grants.catalog_grants, time_sleep.catalog_grant]
  for_each      = toset(var.schemas)
  catalog_name  = databricks_catalog.this.name
  name          = each.value
  storage_root  = var.schemas_get_isolated_buckets ? "s3://${module.schema_external_locations[each.value].bucket_name}/" : null
  force_destroy = false
}

resource "databricks_grants" "schema_grants" {
  depends_on = [databricks_schema.schemas]
  for_each   = var.schema_grants
  schema     = databricks_schema.schemas[each.key].id

  dynamic "grant" {
    for_each = each.value
    content {
      principal  = var.principal_lookup[grant.value["principal"]]
      privileges = grant.value["privileges"]
    }
  }
}
