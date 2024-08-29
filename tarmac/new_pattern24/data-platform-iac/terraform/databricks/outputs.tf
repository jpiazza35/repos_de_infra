output "artifact_instance_profile" {
  value = module.instance_profile.instance_profile_name
}

output "artifact_s3_bucket" {
  value = module.artifact_bucket.bucket_name
}

output "bigeye_vault_secret_path" {
  value = local.deploy_bigeye ? module.bigeye_sql_endpoint[0].vault_path : null
}

output "reltio_vault_secret_path" {
  value = module.reltio_sql_endpoint.vault_path
}

output "mpt_sp_id" {
  value = databricks_service_principal.mpt.application_id
}
output "rfi_service_principal_application_id" {
  value = databricks_service_principal.rfi.application_id
}


output "databricks_secrets" {
  value = {
    vault = {
      url_key   = databricks_secret.vault_url.key
      token_key = databricks_secret.vault_token.key
      scope     = databricks_secret_scope.secret_scope.name
    }
  }
}

output "data_workbench" {
  value = {
    service_principal = databricks_service_principal.survey-data-workbench-sp.application_id
    sql_endpoint      = module.dwb_sql_endpoint
  }
}

output "benchmarks" {
  value = {
    service_principal = databricks_service_principal.benchmarks_sp.application_id
    sql_endpoint      = module.benchmarks_sql_endpoint
  }
}
