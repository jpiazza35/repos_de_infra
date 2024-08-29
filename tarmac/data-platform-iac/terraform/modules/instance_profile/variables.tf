

variable "env" {}

variable "name" {
  description = "Name of the instance profile to create"
}

variable "iam_policy_json" {
  description = "IAM policy JSON that must be created in the target account of the IAM role. It will be linked to trust the Databricks account."
}

locals {
  qualified_name = "${var.env}-${var.name}"
}
