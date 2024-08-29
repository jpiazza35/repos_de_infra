variable "tags" {
  type = map(string)
}

variable "create_sqs" {
  type        = bool
  description = "Whether to create the SQS resources."
}

variable "sqs_kms_key_alias" {
  type        = string
  description = "The KMS key alias used to encrypt sqs queues created with KMS module."
}

variable "sqs_vpc_endpoint_id" {
  type        = string
  description = "The ID of the SQS VPC endpoint created with VPC module."
}

variable "region" {
  description = "The AWS region to launch resources in."
  default     = "eu-central-1"
  type        = string
}

variable "proxy_dev_aws_account_id" {
}

variable "proxy_test_aws_account_id" {
}

variable "proxy_prod_aws_account_id" {
}

variable "shared_services_aws_account_id" {
}

variable "security_aws_account_id" {
}

variable "logging_aws_account_id" {
}

variable "networking_aws_account_id" {
}

variable "infra_code_aws_account_id" {
}

variable "master_aws_account_id" {
}