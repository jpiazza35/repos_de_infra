
variable "tags" {
  type = map(string)
}

variable "region" {
}

variable "profile" {
}

variable "create_lambda_resources" {
  type        = bool
  description = "Whether to create the SSO Lambda resources - true in root AWS account."
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

variable "cw_log_groups_kms_key_arn" {
  description = "The KMS key used for encrypting CW log groups."
  type        = string
}

variable "cw_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
}

variable "lambda_cw_schedule_expression" {
  type        = string
  description = "The rate expression on when to trigger the SSO lambda functions."
}

variable "dyndb_table_name" {
  type        = string
  description = "The name of the DynamoDB table used to store SSO users."
}

variable "dyndb_read_capacity" {
  type        = string
  description = "The RCU for the DynamoDB table."
}

variable "dyndb_write_capacity" {
  type        = string
  description = "The WCU for the DynamoDB table."
}

variable "dyndb_sso_users_list_hash_key" {
  type        = string
  description = "The partition (hash( key for the SSO dynamodb table."
}

variable "dyndb_sso_users_list_range_key" {
  type        = string
  description = "The sort (range) key for the SSO dynamodb table."
}

variable "assume_lambda_role_policy" {
}

variable "assume_events_role_policy" {
}

variable "sns_topic_arn" {
  type        = string
  description = "The arn of the AWS SNS topic to send notification from the lambda functions"
}

##dynamo db variables for the IAM and SSO failed logins notifications.
variable "dyndb_iam_failed_table_name" {
  type        = string
  description = "The name of the DynamoDB table used to store IAM failed logins."
}

variable "dyndb_failed_logins_hash_key" {
  type        = string
  description = "The partition (hash) key for the IAM and SSO failed logins dynamodb table."
}

variable "dyndb_failed_logins_range_key" {
  type        = string
  description = "The sort (range) key for the IAM and SSO failed logins dynamodb table."
}

variable "sso_failed_login_cloudtrail" {
  type        = bool
  description = "Whether to send CloudTrail logs to logs to Cloudwatch"
}

variable "s3_kms_key_alias" {
  description = "Name of the KMS key for the S3 bucket for logs."
}

variable "cloudtrail_kms_key_arn" {
  description = "The AWS KMS key ARN used to encrypt the Cloudtrail logs."
  type        = string
}

variable "dyndb_sso_failed_table_name" {
  type        = string
  description = "The name of the DynamoDB table used to store SSO failed logins."
}

variable "sns_topic_cmk_arn" {
  type        = string
  description = "The cmk key of the AWS SNS topic to send notification from the lambda functions"
}

variable "account_assignments" {
  description = "Map of lists of maps containing mapping between groups, permission sets and AWS accounts."
  type        = any

  default = {}
}

variable "permission_sets" {
  description = "Map of maps containing Permission Set names as keys."
  type        = any
  default     = {}
}

variable "sso_users" {
  description = "A map of AWS SSO users."
  type = map(object({
    user_name    = string
    display_name = string
    given_name   = string
    family_name  = string
    sso_groups   = list(string)

    emails = list(object({
      value   = string,
      primary = bool,
      type    = string,
    }))
  }))
}
