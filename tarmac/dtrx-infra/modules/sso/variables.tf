
variable "tags" {
  type = map(string)
}

variable "region" {
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

variable "dyndb_hash_key" {
  type        = string
  description = "The partition (hash( key for the SSO dynamodb table."
}

variable "dyndb_range_key" {
  type        = string
  description = "The sort (range) key for the SSO dynamodb table."
}

variable "logging_account_sqs_queue_url" {
  type        = string
  description = "The URL for the SQS queue in the Logging & Monitoring AWS account."
}

variable "assume_lambda_role_policy" {
}

variable "logging_aws_account_id" {
}

variable "security_aws_account_id" {
}

variable "shared_services_aws_account_id" {
}

variable "proxy_dev_aws_account_id" {
}

variable "proxy_test_aws_account_id" {
}

variable "proxy_prod_aws_account_id" {
}

variable "networking_aws_account_id" {
}

variable "infra_code_aws_account_id" {
}