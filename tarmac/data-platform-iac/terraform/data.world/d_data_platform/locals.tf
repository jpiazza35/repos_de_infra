locals {
  source_input = flatten([
    for input in local.databases : [
      for db_name in input.db_names : {
        db_type                 = input.db_type
        db_host                 = input.db_host
        db_user                 = input.db_user
        db_pass                 = input.db_pass
        db_name                 = db_name
        upload_location_dataset = input.upload_location_dataset
      }
    ]
  ])
  databases = {
    # MSSQL Server
    mssql_db = {
      db_type = "catalog-sqlserver"
      db_host = data.vault_generic_secret.prod-mssql-db.data["sqlserver-hostname"]
      db_user = data.vault_generic_secret.prod-mssql-db.data["sqlserver-username"]
      db_pass = data.vault_generic_secret.prod-mssql-db.data["sqlserver-password"]
      db_names = [
        "APP_Pref_PROD",
        "Benchmark_PROD",
        "CPT_PROD",
        "Client_Portal_PROD",
        "DAB_PROD",
        "Data_Clearing_House_PROD",
        "EDW_PROD",
        "Insights360_PROD",
        "Market_Pricing_PROD",
        "PNA_PROD",
        "Pay_Practices_PROD",
        "PracticeDB_PROD",
        "PracticeDB_Reporting_PROD",
        "Survey_Audit_PROD",
        "WorkForce_Analytics_PROD",
        "WorkForce_Metrics_PROD"
      ]
      upload_location_dataset = "ddw-microsoft-sql-server-catalog-sandbox"
    }
    # PostgreSQL Server
    incumbent_db = {
      db_type = "catalog-postgres"
      db_host = data.vault_generic_secret.prod-incumbent-db.data["host"]
      db_user = data.vault_generic_secret.prod-incumbent-db.data["admin_db_username"]
      db_pass = data.vault_generic_secret.prod-incumbent-db.data["admin_db_password"]
      db_names = [
        "Incumbent_DB",
        "Incumbent_Staging_DB",
        "Market_Pricing_DB"
      ]
      upload_location_dataset = "ddw-generic-resources-catalog-sandbox"
    }
    # PostgreSQL Server
    ces_db = {
      db_type = "catalog-postgres"
      db_host = data.vault_generic_secret.prod-ces-db.data["ces-hostname"]
      db_user = data.vault_generic_secret.prod-ces-db.data["ces-username"]
      db_pass = data.vault_generic_secret.prod-ces-db.data["ces-password"]
      db_names = [
        "sca_ces_portal_prod"
      ]
      upload_location_dataset = "ddw-generic-resources-catalog-sandbox"
    }
    # Tableau Server
    tableau = {
      db_type = "catalog-tableau"
      db_host = data.vault_generic_secret.prod-tableau.data["tableau_api_host"]
      db_user = data.vault_generic_secret.prod-tableau.data["tableau_pta_name"]
      db_pass = data.vault_generic_secret.prod-tableau.data["tableau_pta_token"]
      db_names = [
        "PNA"
      ]
      upload_location_dataset = "ddw-tableau-catalog-sandbox"
    }
    # Databricks Server
    databricks = {
      db_type = "catalog-databricks"
      db_host = data.vault_generic_secret.nonprod-databricks.data["server"]
      db_user = data.vault_generic_secret.nonprod-databricks.data["http-path"]
      db_pass = data.vault_generic_secret.nonprod-databricks.data["token"]
      db_names = [
        "domain_oriented",
        "hive_metastore",
        "landing",
        "np_usecase_oriented",
        "project_mariner",
        "rocinante",
        "samples",
        "source_oriented",
        "usecase_oriented"
      ]
      upload_location_dataset = "ddw-databricks-catalog-sandbox"
    }
    # Redshift Server
    redshift = {
      db_type = "catalog-redshift"
      db_host = data.vault_generic_secret.prod-redshift.data["endpoint"]
      db_user = data.vault_generic_secret.prod-redshift.data["user"]
      db_pass = data.vault_generic_secret.prod-redshift.data["password"]
      db_names = [
        "edw_prod"
      ]
      upload_location_dataset = "ddw-generic-resources-catalog-sandbox"
    }
    # AWS S3
    s3 = {
      db_type = "catalog-amazon-s3"
      db_host = "null"
      db_user = "null"
      db_pass = "null"
      db_names = [
        "sc-edw-prod-lake01-447179157197-us-east-1"
      ]
      upload_location_dataset = "ddw-aws-s3-catalog-sandbox"
    }
  }

  security_group_id = {
    for k, v in module.ecs : k => v.aws_security_group_id
  }
  ecs_cluster_name = {
    for k, v in module.ecs : k => v.ecs_cluster_name
  }
  container_name = {
    for k, v in module.ecs : k => v.ecs_container_id
  }

  flat_db_names = flatten(local.source_input)
}
