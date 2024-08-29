## Provider variables
variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "default"
}

## Enviornment variables
variable "tags" {
  default = { "Tag" : "Dev" }
}

## s3 Bucket variables
variable "s3_bucket_envs" {
  default = { "Environment" : "Dev" }
}

variable "s3_bucket_name" {
  default = "website-test-module-fh"
}

variable "s3_bucket_prefix" {
  default = "dev"
}

variable "s3_bucket_acl" {
  default = "private"
}

variable "s3_bucket_configuration_index" {
  default = "index.html"
}

variable "s3_bucket_configuration_error" {
  default = "error.html"
}

variable "s3_bucket_block_public_acls" {
  default = true
}

variable "s3_bucket_block_public_policy" {
  default = true
}

variable "s3_bucket_block_public_restrict" {
  default = true
}

variable "s3_bucket_block_public_ignore_acls" {
  default = true
}
variable "s3_bucket_routing_rule_enable" {
  default = false
}
variable "s3_bucket_key_prefix_equals" {
  default = ""
}
variable "s3_bucket_replace_key_prefix_with" {
  default = ""
}

#s3 bucket log variable & distribuion log variables
variable "s3_bucket_log_name" {
  default = "s3BucketLog"
}

variable "distribution_access_log_include_cookies" {
  default = false
}
variable "distribution_access_log_prefix" {
  default = ""
}
variable "distribution_access_logging_enabled" {
  default = true
}

## CloudFront Distribution variables
#if distribution_aliases_enable = true --> aliases= distribution_aliases + var.distribution_external_aliases
variable "distribution_aliases_enable" {
  default = false
}
variable "distribution_aliases" {
  default = [""]
}
variable "distribution_external_aliases" {
  default = [""]
}

variable "oai_comment" {
  default = "Access to website s3 content"
}

variable "distribution_enable" {
  default = true
}

variable "distribution_ipv6" {
  default = true
}

variable "distribution_comment" {
  default = "Cloudfront distribution testing module"
}

variable "distribution_default_min_ttl" {
  default = 0
}

variable "distribution_default_ttl" {
  default = 3600
}

variable "distribution_default_max_ttl" {
  default = 86400
}

variable "distribution_price_class" {
  default = "PriceClass_100"
}

variable "distribution_restriction_type" {
  default = "whitelist"
}
variable "distribution_restriction_locations" {
  default = ["UY"]
}
variable "distribution_viewer_certificate" {
  default = true
}

### Default variables
variable "distribution_default_cache_allowed_methods" {
  default = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}
variable "distribution_default_cached_methods" {
  default = ["GET", "HEAD"]
}
variable "distribution_default_forwarded_query_string" {
  default = false
}
variable "distribution_default_cookies_forward" {
  default = "none"
}
variable "distribution_default_viewer_protocol" {
  default = "allow-all"
}

### Ordered variables
variable "distribution_ordered_path" {
  default = "/*"
}
variable "distribution_ordered_allowed_methods" {
  default = ["GET", "HEAD", "OPTIONS"]
}
variable "distribution_ordered_cached_methods" {
  default = ["GET", "HEAD", "OPTIONS"]
}
variable "distribution_ordered_forwarded_query_string" {
  default = false
}
variable "distribution_ordered_forwarded_headers" {
  default = ["Origin"]
}
variable "distribution_ordered_forwarded_cookies" {
  default = "none"
}
variable "distribution_ordered_min_ttl" {
  default = 0
}
variable "distribution_ordered_ttl" {
  default = 86400
}
variable "distribution_ordered_max_ttl" {
  default = 31536000
}
variable "distribution_ordered_compress" {
  default = true
}
variable "distribution_ordered_viewer_protocol" {
  default = "redirect-to-https"
}

## IAM variables
variable "automation_user_name" {
  default = "dev-automation"
}
variable "automation_user_path" {
  default = "/"
}