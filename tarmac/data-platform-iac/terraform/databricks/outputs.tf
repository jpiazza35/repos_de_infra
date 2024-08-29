output "artifact_instance_profile" {
  value = module.instance_profile.instance_profile_name
}

output "artifact_s3_bucket" {
  value = module.artifact_bucket.bucket_name
}

output "data_quality_bucket" {
  value = module.data_quality_bucket.bucket_name
}

output "bigeye_vault_secret_path" {
  value = vault_generic_secret.bigeye-creds.path
}

output "mpt_sp_id" {
  value = databricks_service_principal.mpt.application_id
}
output "rfi_service_principal_application_id" {
  value = databricks_service_principal.rfi.application_id
}
