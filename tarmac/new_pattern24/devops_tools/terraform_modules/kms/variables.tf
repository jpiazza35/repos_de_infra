variable "is_productou" {
  type        = bool
  description = "True if account that uses this is in Product OU."
}

variable "create_ecr_key" {
  type        = bool
  description = "Whether to create a KMS key for ECR - true only in Shared Services account."
}

variable "create_sqs_key" {
  type        = bool
  description = "Whether to create a KMS key for SQS - true only in Logging & Monitoring account."
}

variable "create_cw_log_groups_key" {
  type        = bool
  description = "Whether to create a KMS key for CW Log groups."
}

variable "create_cloudtrail_key" {
  type        = bool
  description = "Whether to create a KMS key for Cloudtrail trails."
}

variable "tags" {
  type = map(any)
}

variable "shared_services_aws_account_id" {
  description = "The Shared Services AWS account ID."
  default     = "044888517122"
}

variable "region" {
  description = "The AWS region to launch resources in."
  default     = "eu-central-1"
  type        = string
}

variable "enable_key_rotation" {
  type        = bool
  description = "Whether to enable KMS keys rotation."
}

variable "proxy_prod_aws_account_id" {
  description = "The proxy-prod AWS account ID."
}

variable "proxy_dev_aws_account_id" {
  description = "The proxy-prod AWS account ID."
}

variable "proxy_test_aws_account_id" {
  description = "The proxy-prod AWS account ID."
}

variable "master_aws_account_id" {
  description = "The root AWS account ID."
}

variable "create_s3_key" {
  type        = bool
  description = "Whether to create a KMS key for S3 buckets"
}

variable "is_logging" {
  type        = bool
  description = "Wheter the account to apply changes is Logging & Monitoring"
  default     = false

}

variable "create_sns_key" {
  type        = bool
  description = "Whether to create a KMS key for SNS Topics"
}