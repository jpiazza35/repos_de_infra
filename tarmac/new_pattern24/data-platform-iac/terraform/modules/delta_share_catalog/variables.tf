variable "catalog_name" {}

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

variable "catalog_grants" {
  description = "Additional catalog level grants, outside of the default, can be configured here."
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
}

variable "catalog_prefix" {
  description = "The prefix to be used for the catalog name."
  type        = string
  default     = ""
}

variable "isolation_mode" {
  description = "The isolation mode for the catalog. The values are ISOLATED for limiting visiblity to the current workspace, and OPEN for visibility in all workspaces."
  type        = string
  default     = "ISOLATED"
}

variable "provider_name" {
  description = "The name of the Delta Sharing provider to use for the catalog. This is set by the provider, and is not configurable."
  type        = string
}

variable "share_name" {
  description = "The name of the Delta Sharing share to use for the catalog. This is set by the provider, and is not configurable."
  type        = string
}