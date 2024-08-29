output "storage_credential_id" {
  value = var.enable_self_trust ? databricks_storage_credential.this[0].id : null
}

output "storage_credential_name" {
  value = var.enable_self_trust ? databricks_storage_credential.this[0].name : null
}

output "iam_role_name" {
  value = aws_iam_role.datalake-s3-bucket-role.name
}

output "iam_role_arn" {
  value = aws_iam_role.datalake-s3-bucket-role.arn
}
