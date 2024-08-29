output "external_location_id" {
  value = databricks_external_location.this.id
}

output "external_location_name" {
  value = databricks_external_location.this.name
}

output "bucket_name" {
  value = var.create_bucket ? module.bucket[0].bucket_name : null
}

output "bucket_arn" {
  value = var.create_bucket ? module.bucket[0].bucket_arn : null
}
