variable "api_gw_arn" {
  type        = string
  description = "The ARN of the AWS API Gw"
}

variable "tags" {
  type = map(string)
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "create_waf_log_configuration" {
  type        = bool
  description = "Whether to create the WAF log configuration resource."
}

variable "waf_log_groups_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used to encrypt Cloudwatch log groups."
}

variable "waf_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
  default     = 180
}
