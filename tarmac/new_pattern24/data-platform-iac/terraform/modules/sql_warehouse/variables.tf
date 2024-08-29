variable "create_vault_secret" {
  type    = bool
  default = true
}

variable "cluster_size" {
  default = "2X-Small"
  validation {
    condition     = contains(["2X-Small", "X-Small", "Small", "Medium", "Large", "X-Large", "2X-Large", "3X-Large", "4X-Large"], var.cluster_size)
    error_message = "The os_type must be one of '2X-Small', 'X-Small', 'Small', 'Medium', 'Large', 'X-Large', '2X-Large', '3X-Large', '4X-Large'."
  }
}

variable "min_num_clusters" {
  type    = number
  default = 1
}

variable "max_num_clusters" {
  type    = number
  default = 2
}

variable "auto_stop_mins" {
  type    = number
  default = 15
}

variable "spot_instance_policy" {
  type    = string
  default = "RELIABILITY_OPTIMIZED"
  validation {
    condition     = contains(["RELIABILITY_OPTIMIZED", "COST_OPTIMIZED"], var.spot_instance_policy)
    error_message = "The spot_instance_policy must be one of 'RELIABILITY_OPTIMIZED', 'COST_OPTIMIZED'."
  }
}

variable "warehouse_type" {
  type    = string
  default = "PRO"
  validation {
    condition     = contains(["CLASSIC", "PRO"], var.warehouse_type)
    error_message = "The warehouse_type must be one of 'CLASSIC', 'PRO'."
  }
}

variable "enable_serverless_compute" {
  type    = bool
  default = true
}

variable "name" {
  type = string
}

variable "tags" {
  type    = any
  default = {}
}
