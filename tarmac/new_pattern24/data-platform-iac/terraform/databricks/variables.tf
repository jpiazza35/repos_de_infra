variable "region" {}

variable "databricks_account_id" {
  default = "ad35a21f-129b-4626-884f-7ee496730a60"
}

variable "unity_catalog_metastore_id" {}

variable "catalogs" {
  type = map(
    object({
      catalog_grants = optional(
        list(
          object(
            {
              principal  = string
              privileges = list(string)
            }
          )
        ), []
      )
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

variable "delta_share_catalogs" {
  type = map(
    object({
      provider_name  = string
      share_name     = string
      catalog_prefix = optional(string, "")
      catalog_grants = optional(
        list(
          object(
            {
              principal  = string
              privileges = list(string)
            }
          )
        ), []
      )
      isolation_mode = optional(string, "ISOLATED")
      comment        = optional(string, "Managed by Terraform")
    })
  )

  default = {}

}


variable "mpt_endpoint" {
  type = object({
    cluster_size     = optional(string, "2X-Small")
    min_num_clusters = optional(number, 1)
    max_num_clusters = optional(number, 2)
  })
}

variable "phy_wkfce_data_science_group_name" {
  default = ""
}
variable "governance_group_name" {
  default = ""
}
variable "finance_analysts_group_name" {
  default = ""
}
variable "marketing_analysts_group_name" {
  default = ""
}

variable "rfi_app_user_group_name" {
  default = ""
}
variable "mpt_developer_group_name" {
  default = ""
}
variable "data_scientist_group_name" {
  default = ""
}
variable "survey_analyst_group_name" {
  default = ""
}
variable "survey_sandbox_readonly_group_name" {
  default = ""
}
variable "survey_developer_group_name" {
  default = ""
}

variable "physician_rfi_submissions_readonly_group_name" {
  default = ""
}
variable "rfi_developer_group_name" {
  default = ""
}
variable "benchmark_developers_group_name" {
  default = ""
}
variable "cbu_emerging_markets_data_science_group_name" {
  default = ""
}
variable "linked_catalog_names" {
  type        = set(string)
  description = "Catalogs external to the workspace that should be linked to this workspace. Useful for CLONE operations when promoting tables directly between workspaces."
  default     = []
}

variable "workspace_id" {}
variable "bigeye_cluster_size" {
  default = "2X-Small"
}


variable "enable_token_use_group_names" {
  type        = list(string)
  description = "List of groups that should be allowed to use tokens. This is in addition to the default groups."
  default     = []
}

variable "fivetran_service_account_id" {
  default = ""
}

variable "auditbooks_user_group_name" {
  default = ""
}

variable "physician_practice_managers_group_name" {
  default = ""
}

variable "nexus_user" {
  description = "Nexus user for global databricks authentication against nexus pip"
}

variable "nexus_password" {
  description = "Nexus password for global databricks authentication against nexus pip"
}

variable "data_platform_account_id" {
  description = "Account ID for D_DATA_PLATFORM or P_DATA_PLATFORM"
}

variable "ces_bucket" {
  description = "Bucket for CES to be mounted as a read only external location"
}

variable "data_quality_bucket_url" {}

variable "eks_aws_account_ids" {
  default = {
    dev = {
      account_id = "946884638317"
      name       = "D_EKS"
    }
    qa = {
      account_id = "063890802877"
      name       = "Q_EKS"
    }
    prod = {
      account_id = "071766652168"
      name       = "P_EKS"
    }
  }
}

variable "alteryx_databricks_service_account_email" {
  description = "The Databricks account email address used for alteryx connections from the survey team"
}
variable "bsr_password" {}

variable "bsr_user" {}

variable "file_api_role_arn" {}

variable "fivetran_cluster_size" {
  default = "2X-Small"
  validation {
    condition     = contains(["2X-Small", "X-Small", "Small", "Medium", "Large", "X-Large", "2X-Large", "3X-Large", "4X-Large"], var.fivetran_cluster_size)
    error_message = "The os_type must be one of '2X-Small', 'X-Small', 'Small', 'Medium', 'Large', 'X-Large', '2X-Large', '3X-Large', '4X-Large'."
  }
}

variable "eks_oidc_arn" {}
variable "eks_oidc_provider" {}

variable "pna_sql_endpoint_size" {
  default = "2X-Small"
  validation {
    condition     = contains(["2X-Small", "X-Small", "Small", "Medium", "Large", "X-Large", "2X-Large", "3X-Large", "4X-Large"], var.pna_sql_endpoint_size)
    error_message = "The sql endpoint size must be one of '2X-Small', 'X-Small', 'Small', 'Medium', 'Large', 'X-Large', '2X-Large', '3X-Large', '4X-Large'."
  }
}

variable "pna_sql_endpoint_spot_instance_policy" {
  default = "COST_OPTIMIZED"
  validation {
    condition     = contains(["COST_OPTIMIZED", "RELIABILITY_OPTIMIZED"], var.pna_sql_endpoint_spot_instance_policy)
    error_message = "The spot instance policy must be one of 'COST_OPTIMIZED', 'RELIABILITY_OPTIMIZED'."
  }
}

variable "pna_bucket" {
  description = "Bucket for PNA to be mounted as a read only external location"
}

variable "sdlc_ds_group_name" {
  default = ""
}

variable "preview_ds_group_name" {
  default = ""
}