variable "vpc_id" {
  description = "The AWS VPC ID."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The AWS account VPC CIDR block."
  type        = string
}

variable "temp_vpc_cidr_block" {
  type        = string
  description = "The temp AWS account VPC CIDR IP range."
}

variable "jump_host_cidr" {
  type        = string
  description = "The jump host CIDR IP range."
}

variable "threedssv_app_host_cidr" {
  type        = string
  description = "The app host CIDR IP range."
  default     = ""
}

variable "private_subnets" {
  description = "A list of all private subnets IDs."
  type        = list(string)
}

variable "private_subnets_cidr_blocks" {
  type = list(string)
}

variable "db_instance_class" {
  description = "The database instance type."
  type        = string
}

variable "db_storage_type" {
  description = "The database storage type."
  type        = string
}

variable "db_storage_encrypted" {
  description = "Sets whether the DB storage is encrypted or not."
  type        = string
}

variable "db_engine" {
  description = "The database engine type (posgtres, mysql)."
  type        = string
}

variable "db_engine_version" {
  description = "The database engine version."
  type        = string
}

variable "db_allocated_storage" {
  description = "The allocated storage to the database."
  type        = number
}

variable "db_max_allocated_storage" {
  description = "The maximum storage that the database can scale up to."
  type        = number
}

variable "db_multi_az" {
  description = "Sets whether the db deploy is multi-az or not."
  type        = string
}

variable "db_backup_retention_period_days" {
  description = "The db backup retention period in days."
  type        = number
}

variable "db_deletion_protection" {
  description = "Sets the deletion protection parameter."
  type        = string
}

variable "db_apply_immediately" {
  type        = string
  description = "Whether to apply changes done to the RDS immediately."
}

variable "db_auto_minor_version_upgrade" {
  type        = string
  description = "Whether to enable the auto minor upgrade setting."
}

variable "db_username" {
  description = "The RDS master username."
  sensitive   = true
}

variable "db_password" {
  description = "The RDS master password."
  sensitive   = true
}

variable "db_database" {
  description = "The RDS master database."
  sensitive   = true
}

variable "db_schema_name" {
  description = "The RDS database schema name."
  sensitive   = true
}

variable "db_port" {
  description = "The RDS master database."
  default     = 5432
}

variable "db_da_crs_sequence" {
  type        = string
  description = "The DA CRS sequence."
  default     = ""
}

variable "db_region_id" {
  description = "The RDS Region Identifier."
}

variable "iam_database_authentication_enabled" {
  type        = string
  description = "Whether to enable IAM authentication on RDS - default is true."
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip making a final snapshot before destroy."
}

variable "db_performance_insights_enabled" {
  description = "Whether to enable Performance Insights."
}

variable "db_performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data."
}

variable "db_performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data."
}

variable "db_monitoring_interval" {
  description = "The Enhanced Monitoring interval. If set to 0, enhanced monitoring is disabled."
}

variable "db_parameter_group_family" {
  description = "The db parameter group family."
}

variable "log_statement_value" {
  description = "The value for the log_statement parameter in the db subnet group."
}

variable "log_min_duration_statement_value" {
  description = "The value for the log_min_duration_statement parameter in the db subnet group."
}

variable "region" {
  description = "The AWS region to launch resources in."
  type        = string
}

variable "internal_dns_id" {
  type        = string
  description = "The private Route53 zone ID."
}

variable "create_r53_record" {
  type        = string
  description = "Whether to create route53 record."
}

variable "rds_internal_dns" {
  type = string
}

variable "create_vpn_sg_rules" {
  type        = string
  description = "Whether to create sg rules for temporary Open VPN."
}

variable "tags" {
  type = map(string)
}

variable "alerts_sns_topic_arn" {
  type        = string
  description = "The general alerts SNS topic in the accounts."
}

variable "lambda_vpc_execution_policy" {
}

variable "assume_lambda_role_policy" {
}

variable "cw_log_groups_kms_key_arn" {
  description = "The KMS key used for encrypting CW log groups."
  type        = string
}

variable "cw_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
}

variable "lambdas_py_runtime" {
  description = "Python version of runtime environment for the RDS lambda functions."
  type        = string
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

variable "db_iam_auth_username" {
  description = "The RDS user used for IAM authentication."
  type        = string
  sensitive   = true
}

variable "sql_file" {
  type        = string
  description = "The filename that contains the SQL commands to be executed."
}

variable "s3_vpc_endpoint_id" {
  type        = string
  description = "The S3 gateway VPC endpoint."
}

variable "db_enhanced_assume_policy" {
  type        = string
  description = "The assume trusted identity policy for the RDS enhanced Monitoring."
}

variable "db_enhanced_monitoring_policy_arn" {
  type        = string
  description = "The policy allowing enhanced monitoring RDS permissions."
}

variable "enabled_cloudwatch_logs_exports" {
  type        = set(string)
  description = "The RDS logs to be sent to Cloudwatch."
}

variable "s3_vpc_endpoint_prefix_id" {
  type        = string
  description = "The prefix list ID for S3 VPC Endpoint."
}

variable "create_ci_cd_lambdas" {
  type        = bool
  description = "Whether to create lambdas for ci_cd"
}

variable "ci_cd_lambdas_source_code_s3_bucket" {
  description = "Bucket containing source code of ci-cd lambdas"
}
