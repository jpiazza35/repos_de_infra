variable "external_storage_admins_display_name" {}
variable "s3_bucket_name" {}
variable "external_storage_label" {}
variable "external_storage_location_label" {}
variable "external_storage_privileges" {}
variable "databricks_workspace_name" {}
variable "dsci_admin" {
  description = "Databricks admin user"
}
variable "prefix" {}
variable "tags" {
  type        = map(any)
  description = "tags to attach to the external location module's resources"
  default = {
    Resource       = "Managed by Terraform"
    Team           = "Data Platform"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}
