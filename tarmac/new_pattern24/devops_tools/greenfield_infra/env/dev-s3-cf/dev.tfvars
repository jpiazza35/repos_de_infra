## Provider variables
region  = "us-east-1"
profile = "default"


## Enviornment variables
tags = { "Enviornment" : "Dev" }

## s3 Bucket variables
s3_bucket_envs                     = { "Bucket" : "Dev" }
s3_bucket_name                     = "website-test-module"
s3_bucket_prefix                   = "dev"
s3_bucket_acl                      = "private"
s3_bucket_configuration_index      = "index.html"
s3_bucket_configuration_error      = "error.html"
s3_bucket_block_public_acls        = true
s3_bucket_block_public_policy      = true
s3_bucket_block_public_restrict    = true
s3_bucket_block_public_ignore_acls = true

## s3 Routing rules
#if s3Bucket_routing_rule_enable     = true --> routing rules are configured
s3_bucket_routing_rule_enable     = false
s3_bucket_key_prefix_equals       = ""
s3_bucket_replace_key_prefix_with = ""

#s3 bucket log variable & distribuion log variables
#s3 bucket is created anyways TODO: make it optional
#if distribution_access_logging_enabled = true -> distribution send access log to s3
#if if distribution_access_logging_enabled = false -> distribution not send logs 
s3_bucket_log_name                      = "website-test-module-log"
distribution_access_logging_enabled     = false
distribution_access_log_include_cookies = false
distribution_access_log_prefix          = ""


## CloudFront aliases#if distribution_aliases_enable = true --> aliases= distribution_aliases + var.distribution_external_aliases
distribution_aliases_enable   = false
distribution_aliases          = [""]
distribution_external_aliases = [""]
## CloudFront Distribution variables
oai_comment                        = "Access to website s3 content"
distribution_enable                = true
distribution_ipv6                  = true
distribution_comment               = "Cloudfront distribution testing module"
distribution_default_min_ttl       = 0
distribution_default_ttl           = 3600
distribution_default_max_ttl       = 86400
distribution_price_class           = "PriceClass_100"
distribution_restriction_type      = "whitelist"
distribution_restriction_locations = ["UY"]
distribution_viewer_certificate    = true

### Default variables
distribution_default_cache_allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
distribution_default_cached_methods         = ["GET", "HEAD"]
distribution_default_forwarded_query_string = false
distribution_default_cookies_forward        = "none"
distribution_default_viewer_protocol        = "allow-all"

### Ordered variables
distribution_ordered_path                   = "/*"
distribution_ordered_allowed_methods        = ["GET", "HEAD", "OPTIONS"]
distribution_ordered_cached_methods         = ["GET", "HEAD", "OPTIONS"]
distribution_ordered_forwarded_query_string = false
distribution_ordered_forwarded_headers      = ["Origin"]
distribution_ordered_forwarded_cookies      = "none"
distribution_ordered_min_ttl                = 0
distribution_ordered_ttl                    = 86400
distribution_ordered_max_ttl                = 31536000
distribution_ordered_compress               = true
distribution_ordered_viewer_protocol        = "redirect-to-https"

## IAM variables
automation_user_name = "dev-automation"
automation_user_path = "/"