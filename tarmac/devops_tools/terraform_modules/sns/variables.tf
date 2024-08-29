
variable "tags" {
  type = map(string)
}

variable "create_sns" {
  type        = bool
  description = "Whether to create the SNS resources."
}

variable "create_sns_codecommit" {
  type        = bool
  description = "Whether to create the SNS resource for codecommit events."
}

variable "region" {
  description = "The AWS region to launch resources in."
  default     = "eu-central-1"
  type        = string
}

variable "logging_aws_account_id" {
}

variable "sns_subscription_email_list" {
  type        = list(string)
  description = "List of email addresses for codecommit SNS Topic"
}

variable "proxy_dev_aws_account_id" {
  type        = string
  description = "The ID of the AWS Product DEV account that is going to send notifications"
}

variable "proxy_test_aws_account_id" {
  type        = string
  description = "The ID of the AWS Product TEST account that is going to send notifications"
}

variable "proxy_prod_aws_account_id" {
  type        = string
  description = "The ID of the AWS Product PROD account that is going to send notifications"
}

variable "master_aws_account_id" {
  type        = string
  description = "The ID of the AWS ROOT account that is going to send notifications"
}

variable "sns_kms_key_alias" {
  description = "Name of the KMS key for the SNS Topics."
}
