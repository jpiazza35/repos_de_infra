

variable "name" {
  description = "Name of the external location"
}

variable "comment" {
  default = "Managed by Terraform"
  type    = string
}

variable "create_bucket" {
  description = "Create a bucket for the external location"
  default     = true
}


variable "s3_bucket" {
  description = "Name of the S3 bucket to use for the external location. Required if create_bucket is false"
  default     = null
}

variable "kms_arn" {
  description = "ARN of the KMS key to used for the external location. Required if create_bucket is false"
  default     = null
}

variable "storage_credential_name" {
  type = string
}

variable "storage_credential_iam_role" {
  type        = string
  description = "Name of the IAM role to use for storage credentials. Module will attach permissions to this role."
}

variable "role_prefix" {}

variable "account_id" {}


variable "extra_grants" {
  type = list(object({
    permissions = list(string)
    principal   = string
  }))
  default = []
}
