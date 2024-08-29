
output "instance_profile_arn" {
  value = databricks_instance_profile.this.instance_profile_arn
}

output "instance_profile_name" {
  value = databricks_instance_profile.this.id
}
