#s3 bucket
variable "s3_bucket" {
  description = "s3 bucket with static content"
}

variable "s3_bucket_configuration_index" {
  description = "s3 bucket default index file"
}

#s3 bucket log
variable "s3_bucket_log" {
  description = "s3 bucket log"
}

variable "oai_comment" {
  description = "Description of OAI resource"
  type        = string
  default     = "Access to website content"
}

#CloudFront aliases
variable "distribution_aliases_enable" {
  description = "Enable aliases"
  type        = bool
  default     = false
}

variable "distribution_aliases" {
  description = "Aliases"
  type        = list(string)
  default     = [""]
}

variable "distribution_external_aliases" {
  description = "External aliases"
  type        = list(string)
  default     = [""]
}

#CloudFront setup
variable "distribution_access_logging_enabled" {
  type        = bool
  default     = true
  description = "Set true to enable delivery of Cloudfront Access Logs to an S3 bucket"
}

variable "distribution_access_log_include_cookies" {
  type        = bool
  default     = false
  description = "Enable logging cookies"
}

variable "distribution_access_log_prefix" {
  type        = string
  default     = ""
  description = "Prefix to use for Cloudfront Access Log object"
}

variable "distribution_enable" {
  description = "Enable distribution"
  type        = bool
  default     = true
}

variable "distribution_ipv6" {
  description = "Enable IPv6"
  type        = bool
  default     = true
}

variable "distribution_comment" {
  description = "Description of distribution resource"
  type        = string
  default     = "Cloudfront distribution"
}

variable "distribution_default_min_ttl" {
  description = "Min TTL default cache"
  type        = number
  default     = 0
}

variable "distribution_default_ttl" {
  description = "Default TTL cache"
  type        = number
  default     = 3600
}

variable "distribution_default_max_ttl" {
  description = "Max TTL default cache"
  type        = number
  default     = 86400
}

## default cache behavior

variable "distribution_default_cache_allowed_methods" {
  description = "default allowed methods"
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "distribution_default_cached_methods" {
  description = "default cached methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "distribution_default_forwarded_query_string" {
  description = "Forwarded values - Query string"
  type        = bool
  default     = false
}

variable "distribution_default_cookies_forward" {
  description = "Forward cookies"
  type        = string
  default     = "none"
}

variable "distribution_default_viewer_protocol" {
  description = "Viewer protocol policy"
  type        = string
  default     = "allow-all"
}

variable "distribution_error_response" {
  description = "Redirects error pages"
  type = list(object({
    error_caching_min_ttl = string
    error_code            = string
    response_code         = string
    response_page_path    = string
  }))
}

# Cache behavior with precedence 0

variable "distribution_ordered_path" {
  description = "Ordered cache path pattern"
  type        = string
  default     = "/*"
}

variable "distribution_ordered_allowed_methods" {
  description = "Ordered cache allowed methods"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]

}

variable "distribution_ordered_cached_methods" {
  description = "Ordered cache methods"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "distribution_ordered_forwarded_query_string" {
  description = "Ordered forwarded values Query string"
  type        = bool
  default     = false
}

variable "distribution_ordered_forwarded_headers" {
  description = "Ordered forwarded values Headers"
  type        = list(string)
  default     = ["Origin"]
}

variable "distribution_ordered_forwarded_cookies" {
  description = "Ordered forwarded cookies"
  type        = string
  default     = "none"
}

variable "distribution_ordered_min_ttl" {
  description = "Min TTL ordered cache"
  type        = number
  default     = 0
}

variable "distribution_ordered_ttl" {
  description = "Ordered default TTL cache"
  type        = number
  default     = 86400
}

variable "distribution_ordered_max_ttl" {
  description = "Max TTL ordered cache"
  type        = number
  default     = 31536000
}

variable "distribution_ordered_compress" {
  description = "Ordered compress"
  type        = bool
  default     = true
}

variable "distribution_ordered_viewer_protocol" {
  description = "ordered viewer protocol policy"
  type        = string
  default     = "redirect-to-https"
}

variable "distribution_price_class" {
  description = "Type of distribution"
  type        = string
  default     = "PriceClass_100"
}

variable "distribution_restriction_type" {
  description = "Type of restriction method"
  type        = string
  default     = "whitelist"
}

variable "distribution_restriction_locations" {
  description = "List of locations"
  type        = list(string)
  default     = ["UY"]
}

variable "distribution_viewer_certificate" {
  description = "Auto generate default certificate"
  type        = bool
  default     = true
}

variable "distribution_acm_certificate" {
  description = "Valid certificate for distribution"
  type        = string
  default     = ""
}
variable "distribution_ssl_support_method" {
  description = "SSL support method"
  type        = string
  default     = "sni-only"
}

variable "tags" {
  type = map(any)
}







