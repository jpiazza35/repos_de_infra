
variable "env" {}

variable "env_prefix" {}

variable "catalog_name" {}

variable "account_id" {
  description = "Account number of the databricks workspace."
}

variable "owner_service_principal_id" {
  description = "The application id of the service principal that will retain ownership over all catalogs and schemas."
}

variable "schemas_get_isolated_buckets" {
  type        = bool
  default     = false
  description = "By default, the catalog will have a single bucket that all schemas are stored in. With this turned on, each schema will have its own bucket in addition to the catalog root bucket."
}

variable "schemas" {
  type = list(string)
}

variable "schema_grants" {
  description = "Schemas can only have a single `databricks_grants` resource. By default, only the grants are configured at the `catalog` level. If you need to configure grants at the schema level, you can do so here."
  type = map(list(object({
    principal  = string
    privileges = list(string)
  })))
  default = {}
}

variable "principal_lookup" {
  type        = map(string)
  description = "If additional grants on schemas are to be made, this map can be used to lookup the principal name required for `databricks_grants`."
  default     = {}
}

variable "metastore_id" {
  type = string
}

variable "comment" {
  type    = string
  default = "Managed by Terraform"
}


variable "role_prefix" {}

variable "storage_credential_iam_role" {
  type = string
}

variable "storage_credential_name" {
  type = string
}

variable "extra_catalog_grants" {
  description = "Additional catalog level grants, outside of the default, can be configured here."
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
}
