variable "secrets_vpc_endpoint_id" {
  description = "The Secrets Manager VPC endpoint ID - managed within VPC module."
  type        = string
}

variable "organization_id" {
  description = "The ID of the AWS Organizational Unit."
  type        = string
}

variable "region" {
  description = "The AWS region to launch resources in."
  type        = string
}

variable "tags" {
  type = map(string)
}

variable "recovery_window_in_days" {
  description = "The recovery window in days that Secrets Manager waits before deleting the secret."
  type        = string
}
