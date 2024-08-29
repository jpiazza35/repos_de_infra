


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

  # engineers have special privileges for troubleshooting
  # todo: extract this somewhere else
  grant {
    principal  = "${var.role_prefix}_engineer"
    privileges = ["CREATE_FUNCTION", "CREATE_SCHEMA", "CREATE_TABLE", "CREATE_VOLUME", "MODIFY", "SELECT", "USE_CATALOG", "USE_SCHEMA", "WRITE_VOLUME", "READ_VOLUME"]
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
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = var.owner_service_principal_id
    privileges = ["USE_CATALOG", "CREATE_SCHEMA", "USE_SCHEMA"]
  }


  dynamic "grant" {
    # all unique schema principals that don't have a catalog grant. Otherwise there will be conflict
    for_each = setsubtract(toset(local.unique_schema_principals), toset(local.unique_catalog_principals))
    #for_each = toset(local.unique_schema_principals) - toset(local.unique_catalog_principals)
    content {
      principal  = var.principal_lookup[grant.value]
      privileges = ["USE_CATALOG"]
    }
  }

  dynamic "grant" {
    for_each = var.catalog_grants
    content {
      principal  = var.principal_lookup[grant.value.principal]
      privileges = grant.value.privileges
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
  all_catalog_principals = [
    for grant in var.catalog_grants : grant.principal
  ]
  unique_catalog_principals = distinct(local.all_catalog_principals)
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

resource "databricks_volume" "schema_volume" {
  depends_on   = [databricks_schema.schemas]
  for_each     = toset(var.schemas)
  catalog_name = databricks_catalog.this.name
  name         = "${each.value}_volume"
  schema_name  = each.value
  volume_type  = "MANAGED"
}


resource "databricks_grants" "volumes" {
  for_each = toset(var.schemas)
  volume   = databricks_volume.schema_volume[each.key].id


  grant {
    principal  = "${var.role_prefix}_engineer"
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = "${var.role_prefix}_scientist"
    privileges = ["ALL_PRIVILEGES"]
  }

  grant {
    principal  = "${var.role_prefix}_user"
    privileges = ["READ_VOLUME"]
  }
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
