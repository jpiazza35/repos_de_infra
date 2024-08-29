variable "environment" {
  type = string
}

variable "s3_bucket_envs" {
  description = "Environment"
  type        = map(string)
  default     = { "Environment" : "Dev" }
}

variable "tags" {
  type = map(any)
}

#s3 bucket
variable "s3_bucket_name" {
  description = "Name s3 bucket website data"
  type        = string
  default     = "s3Bucket"
}

variable "s3_bucket_prefix" {
  description = "s3 Environment prefix"
  type        = string
  default     = "dev" #dev-s3bucket_name
}

variable "s3_bucket_acl" {
  description = "s3 bucket acl"
  type        = string
  default     = "private"
}

variable "s3_bucket_routing_rule_enable" {
  description = "Enable s3 bucket routing rule"
  type        = bool
  default     = false
}
variable "s3_bucket_key_prefix_equals" {
  description = "s3 bucket key prefix"
  type        = string
  default     = ""
}
variable "s3_bucket_replace_key_prefix_with" {
  description = "s3 bucket replace key prefix"
  type        = string
  default     = ""
}

#s3 bucket log TODO: create it reusing s3 module
variable "s3_bucket_log_name" {
  description = "Name s3 bucket website log"
  type        = string
  default     = "s3BucketLog"
}

#s3 bucket website
variable "s3_bucket_configuration_index" {
  description = "html file for default access /index.html"
  type        = string
  default     = "index.html"
}

variable "s3_bucket_configuration_error" {
  description = "html file for error responses"
  type        = string
  default     = "error.html"
}

variable "s3_bucket_block_public_acls" {
  description = "Block public acls"
  type        = bool
  default     = true
}

variable "s3_bucket_block_public_policy" {
  description = "Block public policy"
  type        = bool
  default     = true
}

variable "s3_bucket_block_public_restrict" {
  description = "Restrict public buckets"
  type        = bool
  default     = true
}

variable "s3_bucket_block_public_ignore_acls" {
  description = "Ignore public acls"
  type        = bool
  default     = true
}

variable "load_balancer_bucket_log_name" {
  description = "Load balancer log bucket name"
  type        = string
  default     = "load-balancer-log"
}

variable "s3_bucket_datalake_name" {
  description = "Datalake bucket name"
  type        = string
  default     = "default-datalake"
}

variable "s3_bucket_scripts_name" {
  description = "Datalake bucket name"
  type        = string
  default     = "default-scripts"
}

variable "account_id_lb_aws" {
  default     = "value"
  type        = string
  description = "someDescription"
}
