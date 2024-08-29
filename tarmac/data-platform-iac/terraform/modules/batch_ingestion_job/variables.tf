variable "tags" {
  type = map(string)
}

variable "env" {
  type = string
}

variable "role_prefix" {
  type = string
}

variable "source_name" {
  type        = string
  description = "Name of the source. PNA, CES, Insights360, Benchmarks, WorkforceAnalytics, etc"
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

variable "named_parameters" {
  type = map(string)
}

variable "package_name" {
  default = "cn_databricks"
}

variable "entry_point" {
  default = "batch_ingestion"
}

variable "instance_profile_arn" {
  type        = string
  description = "Instance policy to give permission to download wheels from S3."
}

locals {
  spark_version = var.job_cluster.spark_version == null ? data.databricks_spark_version.latest.id : var.job_cluster.id
  node_type_id  = var.job_cluster.node_type_id == null ? data.databricks_node_type.smallest.id : var.job_cluster.node_type_id
  source_id     = replace(lower("${var.source_name}-${var.env}"), " ", "-")
}
