variable "tags" {
  type = map(string)
}

variable "is_example_server" {
  description = "Whether the app running the terraform is 3ds-server."
  type        = bool
  default     = false
}

variable "create_pipeline_trail" {
  description = "Whether to create Cloud Trail for Code Pipeline"
  default     = false
  type        = bool
}
variable "cloudtrail_kms_key_id" {
  description = "The AWS KMS key ID used to encrypt the Cloudtrail logs."
  type        = string
}

variable "cloudtrail_kms_key_arn" {
  description = "The AWS KMS key ARN used to encrypt the Cloudtrail logs."
  type        = string
}

variable "cw_log_groups_kms_key_arn" {
  description = "The AWS KMS key ARN used to encrypt the Cloudwatcj log groups."
  type        = string
}

variable "s3_vpc_endpoint_id" {
  description = "The AWS S3 VPC endpoint ID."
  type        = string
}

variable "shared_services_aws_account_id" {
  description = "The Shared Services AWS account ID."
}

variable "region" {
  description = "The AWS region to launch resources in."
  default     = "eu-central-1"
  type        = string
}

variable "cloudtrail_enable_log_file_validation" {
  description = "Whether to enable log file validation in the Cloutrail(s)."
  type        = bool
}

variable "pipeline_source_s3_bucket_arns" {
  type        = list(string)
  description = "The list of the pipeline-source s3 buckets."
}

variable "cw_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
}