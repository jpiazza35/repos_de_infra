variable "github_enterprise_token" {
  type        = string
  description = "The GitHub Enterprise token to use for the Databricks Repo"
}

variable "github_username" {
  type        = string
  description = "The GitHub user to use for the Databricks Repo"
}

variable "workflow_node_type" {
  type        = string
  description = "Job cluster node type"
  default     = "i4i.large"
}

variable "spark_version" {
  type        = string
  description = "Spark version to use for the job cluster"
  default     = "13.1.x-scala2.12"
}