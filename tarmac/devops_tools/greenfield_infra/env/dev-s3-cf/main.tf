module "s3" {
  source                        = "../../modules/s3"
  s3_bucket_envs                = var.s3_bucket_envs
  tags                          = var.tags
  s3_bucket_name                = var.s3_bucket_name
  s3_bucket_prefix              = var.s3_bucket_prefix
  s3_bucket_acl                 = var.s3_bucket_acl
  s3_bucket_configuration_index = var.s3_bucket_configuration_index
  s3_bucket_configuration_error = var.s3_bucket_configuration_error
  s3_bucket_log_name            = var.s3_bucket_log_name
}

module "cloudfront" {
  source                        = "../../modules/cloudfront"
  s3_bucket                     = module.s3.s3_bucket
  s3_bucket_configuration_index = module.s3.s3_bucket_configuration_index
  s3_bucket_log                 = module.s3.s3_bucket_log
  oai_comment                   = var.oai_comment
  tags                          = var.tags

  #s3 bucket log variable & distribuion log variables
  #s3 bucket is created anyways TODO: make it optional
  #if distribution_access_logging_enabled = true -> distribution send access log to s3
  #if if distribution_access_logging_enabled = false -> distribution not send logs 
  #Cloudfront setup
  distribution_access_logging_enabled = var.distribution_access_logging_enabled
  distribution_enable                 = var.distribution_enable
  distribution_ipv6                   = var.distribution_ipv6
  distribution_comment                = var.distribution_comment
  distribution_default_min_ttl        = var.distribution_default_min_ttl
  distribution_default_ttl            = var.distribution_default_ttl
  distribution_default_max_ttl        = var.distribution_default_max_ttl
  distribution_price_class            = var.distribution_price_class
  distribution_restriction_type       = var.distribution_restriction_type
  distribution_restriction_locations  = var.distribution_restriction_locations
  distribuion_viewer_certificate      = var.distribution_viewer_certificate
  #if distribution_aliases_enable = true --> aliases= distribution_aliases + var.distribution_external_aliases
  distribution_aliases_enable   = var.distribution_aliases_enable
  distribution_aliases          = var.distribution_aliases
  distribution_external_aliases = var.distribution_external_aliases
  #Default cache behavior
  distribution_default_cache_allowed_methods  = var.distribution_default_cache_allowed_methods
  distribution_default_cached_methods         = var.distribution_default_cached_methods
  distribution_default_forwarded_query_string = var.distribution_default_forwarded_query_string
  distribution_default_cookies_forward        = var.distribution_default_cookies_forward
  distribution_default_viewer_protocol        = var.distribution_default_viewer_protocol
  # Cache behavior with precedence 0 | TODO: Make it a list to create many cache ordered
  distribution_ordered_path                   = var.distribution_ordered_path
  distribution_ordered_allowed_methods        = var.distribution_ordered_allowed_methods
  distribution_ordered_cached_methods         = var.distribution_ordered_cached_methods
  distribution_ordered_forwarded_query_string = var.distribution_ordered_forwarded_query_string
  distribution_ordered_forwarded_headers      = var.distribution_ordered_forwarded_headers
  distribution_ordered_forwarded_cookies      = var.distribution_ordered_forwarded_cookies
  distribution_ordered_min_ttl                = var.distribution_ordered_min_ttl
  distribution_ordered_ttl                    = var.distribution_ordered_ttl
  distribution_ordered_max_ttl                = var.distribution_ordered_max_ttl
  distribution_ordered_compress               = var.distribution_ordered_compress
  distribution_ordered_viewer_protocol        = var.distribution_ordered_viewer_protocol

}

module "iam" {
  source                 = "../../modules/iam"
  s3_bucket_distribution = module.cloudfront.s3_bucket_distribution
  s3_bucket              = module.s3.s3_bucket
  s3_bucket_log          = module.s3.s3_bucket_log
  automation_user_name   = var.automation_user_name
  automation_user_path   = var.automation_user_path
}