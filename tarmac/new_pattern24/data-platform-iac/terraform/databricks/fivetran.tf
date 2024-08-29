module "fivetran_sql_endpoint" {
  source = "../modules/sql_warehouse"
  name   = "fivetran-sql-endpoint"
  tags   = local.tags
}

module "fivetran_warehouse_permissions" {
  source = "../modules/permissions/sql_warehouse"

  sql_endpoint_id = module.fivetran_sql_endpoint.id
  workspace       = module.workspace_vars.env
  additional_user_permissions = [
    {
      user_name        = var.fivetran_service_account_id
      permission_level = "CAN_MANAGE"
    }
  ]
}

resource "fivetran_group" "databricks_source_oriented_catalog" {
  name = "databricks_${module.workspace_vars.env}_${module.workspace_vars.env_prefix}_source_oriented"
}

resource "fivetran_destination" "databricks_source_oriented_catalog" {
  group_id           = fivetran_group.databricks_source_oriented_catalog.id
  service            = "databricks"
  time_zone_offset   = "-5"
  region             = "AWS_US_EAST_1"
  trust_certificates = "true"
  trust_fingerprints = "true"
  run_setup_tests    = "true"

  config {
    server_host_name       = "cn-${module.workspace_vars.env}-databricks.cloud.databricks.com"
    catalog                = "${module.workspace_vars.env_prefix}_source_oriented"
    port                   = 443
    http_path              = "/sql/1.0/warehouses/${module.fivetran_sql_endpoint.id}"
    personal_access_token  = data.vault_generic_secret.fivetran_service_account.data["personal_access_token"]
    create_external_tables = "false"
    connection_type        = "PrivateLink"
  }
}

resource "fivetran_connector" "repl_benchmark" {
  depends_on = [
    fivetran_destination.databricks_source_oriented_catalog
  ]

  group_id = fivetran_destination.databricks_source_oriented_catalog.group_id
  service  = "sql_server_rds"

  destination_schema {
    prefix = "repl_benchmark"
  }

  config {
    host             = data.vault_generic_secret.benchmark_credentials.data["fivetran_database_connection_host"]
    port             = data.vault_generic_secret.benchmark_credentials.data["fivetran_mssql_database_connection_port"]
    database         = data.vault_generic_secret.benchmark_credentials.data["benchmark_database_name"]
    user             = data.vault_generic_secret.benchmark_credentials.data["username"]
    password         = data.vault_generic_secret.benchmark_credentials.data["password"]
    update_method    = data.vault_generic_secret.benchmark_credentials.data["update_method"]
    connection_type  = "PrivateLink"
    always_encrypted = true
  }

  lifecycle {
    ignore_changes = [
      config.public_key
    ]

  }
}

resource "fivetran_connector_schedule" "repl_benchmark_connector_schedule" {
  connector_id   = fivetran_connector.repl_benchmark.id
  sync_frequency = 120
  paused         = false
}


resource "fivetran_connector" "repl_ces" {
  depends_on = [
    fivetran_destination.databricks_source_oriented_catalog
  ]

  group_id = fivetran_destination.databricks_source_oriented_catalog.group_id
  service  = "postgres_rds"

  destination_schema {
    prefix = "repl_ces"
  }

  config {
    host             = data.vault_generic_secret.ces_credentials.data["fivetran_database_connection_hostname"]
    port             = data.vault_generic_secret.ces_credentials.data["fivetran_psql_database_connection_port"]
    database         = data.vault_generic_secret.ces_credentials.data["database"]
    user             = data.vault_generic_secret.ces_credentials.data["username"]
    password         = data.vault_generic_secret.ces_credentials.data["password"]
    update_method    = data.vault_generic_secret.ces_credentials.data["update_method"]
    replication_slot = data.vault_generic_secret.ces_credentials.data["replication_slot"]
    connection_type  = "PrivateLink"
  }
}

resource "fivetran_connector_schedule" "repl_ces_connector_schedule" {
  connector_id   = fivetran_connector.repl_ces.id
  sync_frequency = 5
  paused         = false
}
