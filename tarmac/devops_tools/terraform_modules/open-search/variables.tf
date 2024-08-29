variable "create_opensearch" {
  type        = bool
  description = "Whether to crate OpenSearch resources."
}

variable "send_cloudtrail_logs" {
  type        = bool
  description = "Whether to send CloudTrail logs to OpenSearch Cluster."
}

variable "region" {
  description = "The AWS region to launch resources in."
  default     = "eu-central-1"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "The AWS account VPC ID."
}

variable "example-account_cidr_block" {
  type        = string
  description = "The dtloud CIDR IP range."
}

variable "logging_aws_account_cidr_block" {
  type        = string
  description = "The dtloud CIDR IP range for Logging and Monitoring account."
}

variable "elasticsearch_version" {
  type        = string
  description = "The Elasticsearch version."
  default     = ""
}

variable "open_search_ebs_volume_size" {
  type        = number
  description = "The Elasticsearch EBS volume(s) size."
  default     = 0
}

variable "open_search_ebs_volume_type" {
  type        = string
  description = "The Elasticsearch EBS volume(s) type."
  default     = ""
}

variable "open_search_encrypt_at_rest_enabled" {
  type        = string
  description = "Sets whether encryption at rest is set for the cluster."
  default     = ""
}

variable "open_search_instance_count" {
  type        = number
  description = "The number of data nodes."
  default     = 0
}

variable "open_search_instance_type" {
  type        = string
  description = "The ES node(s) type."
  default     = ""
}

variable "open_search_dedicated_master_enabled" {
  type        = string
  description = "Sets whether a dedicated master is enabled."
  default     = ""
}

variable "open_search_advanced_security_options_enabled" {
  type        = string
  description = "Sets whether a fine-grained acces control is enabled."
  default     = ""
}

variable "open_search_dedicated_master_count" {
  type        = string
  description = "Sets how many dedicated master nodes are created."
  default     = ""
}

variable "open_search_dedicated_master_type" {
  type        = string
  description = "The dedicated master node(s) type."
  default     = ""
}

variable "open_search_zone_awareness_enabled" {
  type        = string
  description = "Sets whether zone awareness is enabled (multi-az)."
  default     = ""
}

variable "open_search_warm_enabled" {
  type        = string
  description = "Whether to enable warm storage."
  default     = ""
}

variable "open_search_warm_count" {
  type        = string
  description = "Number of warm nodes in the cluster."
  default     = ""
}

variable "open_search_warm_type" {
  type        = string
  description = "Instance type for the Elasticsearch cluster's warm nodes."
  default     = ""
}

variable "open_search_availability_zone_count" {
  type        = string
  description = "Sets how many zones are used. Valid only if zone awareness is enabled."
  default     = ""
}

variable "open_search_node_to_node_encryption_enabled" {
  type        = string
  description = "Sets node to node encryption."
  default     = ""
}

variable "open_search_automated_snapshot_start_hour" {
  type        = string
  description = "The start hour when ES does snapshots."
  default     = ""
}

variable "domain_endpoint_options_enforce_https" {
  type        = string
  description = "Whether to enable https enforcement."
  default     = ""
}

variable "domain_endpoint_options_tls_security_policy" {
  type        = string
  description = "Member must satisfy enum value set: [Policy-Min-TLS-1-0-2019-07, Policy-Min-TLS-1-2-2019-07]"
  default     = ""
}

variable "open_search_internal_user_database_enabled" {
  type        = string
  description = "Whether to enable database."
  default     = ""
}

variable "open_search_master_user_name" {
  type        = string
  description = "OpenSearch master user name."
  sensitive   = true
  default     = ""
}

variable "open_search_master_user_password" {
  type        = string
  description = "OpenSearch master password."
  sensitive   = true
  default     = ""
}

variable "private_subnets" {
  type        = list(any)
  description = "Private subnets. Used when OS is in multi-az."
}

variable "private_subnet" {
  description = "One private subnet needed when OS is in single AZ."
}

variable "open_search_domain_name" {
  description = "The domain name for the OpenSearch cluster."
}

variable "open_search_domain_endpoint" {
  description = "The endpoint for the OpenSearch cluster."
}

variable "logging_aws_account_id" {
  description = "The id for the Logging & Monitoring account."
}

variable "cw_log_groups_kms_key_arn" {
  description = "The AWS KMS key ARN used to encrypt Cloudwatch log groups."
  type        = string
}

variable "cloudtrail_kms_key_arn" {
  description = "The AWS KMS key ARN used to encrypt the Cloudtrail logs."
  type        = string
}

variable "cw_retention_in_days" {
  type        = number
  description = "The number in days for the retention of CW log group logs."
}

variable "s3_vpc_endpoint_id" {
  description = "The AWS S3 VPC endpoint ID."
  type        = string
}

variable "cloudtrail_enable_log_file_validation" {
  description = "Whether to enable log file validation in the Cloutrail(s)."
  type        = bool
}

variable "s3_kms_key_alias" {
  description = "Name of the KMS key for the S3 product bucket."
}

variable "tags" {
  type = map(string)
}

variable "assume_lambda_role_policy" {
}
