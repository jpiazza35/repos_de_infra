variable "tags" {
  type = map(any)
}

variable "create_conformance_pack" {
  type        = bool
  description = "Whether to create the conformance pack or not."
}

variable "create_lambda_resources" {
  type        = bool
  default     = true
  description = "Whether to create the Lambda resources or not."
}

variable "s3_kms_key_alias" {
  description = "Name of the KMS key for the S3 product bucket."
}

variable "iam_password_policy_min_password_length" {
  type = number
}

variable "iam_password_policy_require_lowercase" {
  type = bool
}

variable "iam_password_policy_require_uppercase" {
  type = bool
}

variable "iam_password_policy_require_numbers" {
  type = bool
}

variable "iam_password_policy_require_symbols" {
  type = bool
}

variable "iam_password_policy_allow_users_to_change_password" {
  type = bool
}

variable "iam_password_policy_password_reuse_prevention" {
  type = number
}

variable "iam_password_policy_max_password_age" {
  type = number
}

variable "cw_log_groups_kms_key_arn" {
  description = "The AWS KMS key ARN used to encrypt Cloudwatch log groups."
  type        = string
}

variable "cw_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
}

variable "lambda_to_os_arn" {
  type        = string
  description = "The ARN of the Lambda function sending logs to Opensearch."
}

variable "assume_lambda_role_policy" {
}