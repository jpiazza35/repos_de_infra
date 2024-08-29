variable "region" {}

variable "databricks_account_id" {
  default = "ad35a21f-129b-4626-884f-7ee496730a60"
}

variable "unity_catalog_metastore_id" {}




variable "catalogs" {
  type = map(
    object({
      schemas_get_isolated_buckets = optional(bool, false)
      schemas                      = list(string)
      schema_grants = optional(
        map(
          list(
            object(
              {
                principal  = string
                privileges = list(string)
              }
            )
          ),
        ), {}
      )
    })
  )
}


variable "mpt_endpoint" {
  type = object({
    cluster_size     = optional(string, "2X-Small")
    min_num_clusters = optional(number, 1)
    max_num_clusters = optional(number, 2)
  })
}


variable "rfi_app_user_group_name" {}
variable "mpt_developer_group_name" {}

variable "linked_catalog_names" {
  type        = set(string)
  description = "Catalogs external to the workspace that should be linked to this workspace. Useful for CLONE operations when promoting tables directly between workspaces."
  default     = []
}

variable "workspace_id" {}
variable "bigeye_cluster_size" {
  default = "2X-Small"
}
