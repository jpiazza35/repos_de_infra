variable "tags" {
  type = map(string)
}

variable "region" {
  type = string
}

variable "sso_instance" {
}

variable "logging_aws_account_id" {
}

variable "shared_services_aws_account_id" {
}

variable "product_ou_arn" {
}

variable "is_root_aws_account" {
  default     = false
  type        = bool
  description = "Whether the IAM resources are in Root AWS account or other."
}

variable "create_example_machine_user" {
  type        = bool
  description = "Whether to create the machine IAM user for the document vault service."
}

variable "iam_minimum_password_length" {
  description = "The minimum IAM password length."
}

variable "iam_password_require_lowercase_characters" {
  description = "Whether to require lowercase characters in IAM passwords."
}

variable "iam_password_require_numbers" {
  description = "Whether to require numbers in IAM passwords."
}

variable "iam_password_require_uppercase_characters" {
  description = "Whether to require uppercase characters in IAM passwords."
}

variable "iam_password_require_symbols" {
  description = "Whether to require symbols in IAM passwords."
}

variable "iam_allow_users_to_change_password" {
  description = "Whether to allow users to change their IAM password."
}

variable "iam_password_reuse_prevention" {
  description = "The number of previous passwords that users are prevented from reusing."
}

variable "iam_max_password_age" {
  description = "The number of days until users are required to change their IAM password."
}

variable "document_vault_s3_bucket" {
  type        = string
  description = "The name for the Document Vault s3 bucket."
}

variable "create_lambda_resources" {
  type        = bool
  description = "Whether to create the Lambda resources"
}

variable "lambdas_runtime" {
  description = "The runtime environment for the lambda functions."
  type        = string
}

variable "lambdas_timeout" {
  description = "The lambda functions timeout."
  type        = string
}

variable "lambdas_memory_size" {
  description = "The lambda functions memory size."
  type        = string
}

variable "lambda_cw_schedule_expression" {
  type        = string
  description = "The rate expression on when to trigger the SSO lambda functions."
}

variable "sns_topic_arn" {
  type        = string
  description = "The arn of the AWS SNS topic to send notification from machine_user_key_alert.py lambda function"
}

variable "account_name" {
  type        = string
  description = "Name of the current account"
}

variable "days_old_notify" {
  type        = number
  description = "The age of the doc-vault machine user IAM access key(s) in days."
}

variable "assume_lambda_role_policy" {
}

variable "cw_log_groups_kms_key_arn" {
  description = "The AWS KMS key ARN used to encrypt Cloudwatch log groups."
  type        = string
}

variable "cw_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
}