variable "role_prefix" {
  type = string
}

variable "job_cluster" {
  type = object({
    enable_elastic_disk = optional(bool)
    num_workers         = optional(number)
    spark_version       = optional(string)
    node_type_id        = optional(string)
    min_workers         = optional(number)
    max_workers         = optional(number)
  })

  default = {
    enable_elastic_disk = true
    number              = 2
    min_workers         = 2
    max_workers         = 10
  }
}

variable "wheel_path" {
  type = string
}

variable "instance_profile_arn" {
  type = string
}
variable "default_role_prefix" {
  type = string
}

locals {
  spark_version = var.job_cluster.spark_version == null ? "13.3.x-scala2.12" : var.job_cluster.id
  node_type_id  = var.job_cluster.node_type_id == null ? data.databricks_node_type.smallest.id : var.job_cluster.node_type_id
}

variable "cron_schedule" {
  type    = string
  default = "0 0 0 ? * *"
}

variable "cron_schedule_enable" {
  type    = bool
  default = false
}

variable "job_name" {
  type = string
}
variable "deidentification_tasks" {
  type = list(
    object(
      {
        task_name             = string
        source_table_name     = string
        column_name_list      = list(string)
        deidentification_type = optional(string)
        target_table_name     = optional(string)
        salt                  = optional(string)
      }
    )
  )

}