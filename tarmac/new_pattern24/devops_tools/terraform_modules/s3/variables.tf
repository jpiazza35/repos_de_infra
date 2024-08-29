variable "tags" {
  type = map(string)
}

variable "region" {
  description = "The AWS region to launch resources in."
  default     = "eu-central-1"
  type        = string
}

variable "private_subnets" {
  type        = list(any)
  description = "Private subnets."
}

variable "s3_vpc_endpoint_id" {
  description = "The AWS S3 VPC endpoint ID."
  type        = string
}

variable "create_dashboard_vault_bucket" {
  type        = bool
  description = "Whether to create the dashboard vault S3 bucket."
}

variable "prod_doc_vault_s3_bucket_policy" {
  type        = bool
  default     = false
  description = "Whether the S3 bucket policy to attach is the production one."
}

variable "s3_kms_key_alias" {
  description = "Name of the KMS key for the S3 product bucket"
}

variable "example_machine_iam_user" {
  type        = string
  default     = ""
  description = "The name of the Document Vault IAM machine user."
}

variable "retention_in_days" {
  type        = number
  description = "The number of days used in the data retention policy set on the s3 bucket(s)."
}
