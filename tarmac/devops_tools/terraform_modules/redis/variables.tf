variable "create_vpn_sg_rule" {
  type        = bool
  description = "Whether to create the VPN sg rule or not."
}

variable "automatic_failover_enabled" {
  type        = string
  description = "Boolean, whether automatic failover is enabled."
}

variable "multi_az_enabled" {
  type        = string
  description = "Boolean, whether multi az is enabled."
}

variable "redis_instance_type" {
  type        = string
  description = "Redis instance type"
}

variable "redis_engine" {
  type        = string
  description = "Redis engine."
}

variable "apply_immediately" {
  type        = string
  description = "Whether to apply changes to the Elasticache immediately"
}

variable "parameter_group_name" {
  type        = string
  description = "The Elasticache Redis parameter group name."
}

variable "transit_encryption_enabled" {
  type        = string
  description = "Whether the redis data is encrypted in transit."
}

variable "at_rest_encryption_enabled" {
  type        = string
  description = "Whether the redis data is encrypted at rest."
}

variable "vpc_id" {
  type        = string
  description = "The AWS VPC ID."
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of all private subnets IDs."
}

variable "private_subnets_cidr_blocks" {
  type = list(string)
}

variable "vpc_cidr_block" {
  type        = string
  description = "The VPC CIDR IP range."
}

variable "temp_vpc_cidr_block" {
  type        = string
  description = "The temp AWS account VPC CIDR IP range."
}

variable "jump_host_cidr" {
  type        = string
  description = "The jump host CIDR IP range."
}

variable "internal_dns_id" {
  type        = string
  description = "The private Route53 zone ID."
}

variable "create_r53_record" {
  type        = string
  description = "Whether to create route53 record"
}

variable "redis_internal_dns" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "assume_lambda_role_policy" {
}

variable "lambda_vpc_execution_policy" {
}

variable "lambdas_java_runtime" {
  description = "Java version of runtime environment for the RDS lambda functions."
  type        = string
}

variable "lambdas_timeout" {
  description = "The lambdas function timeout."
  type        = string
}

variable "lambdas_memory_size" {
  description = "Lambda function memory size."
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

variable "create_ci_cd_lambdas" {
  type        = bool
  description = "Whether to create lambdas for ci_cd"
}

variable "ci_cd_lambdas_source_code_s3_bucket" {
  description = "Bucket containing source code of ci-cd lambdas"
}

variable "redis_app_username_password" {
  type        = string
  description = "Redis Application username password"
  sensitive   = true
}

variable "redis_app_username" {
  type        = string
  description = "Redis Application username"
  sensitive   = true
}
