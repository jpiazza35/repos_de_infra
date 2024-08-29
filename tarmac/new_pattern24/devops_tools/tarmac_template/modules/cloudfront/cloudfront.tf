## Cloudfront OAI setup
resource "aws_cloudfront_origin_access_identity" "s3_bucket_distribution_oai" {
  comment = var.oai_comment
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = var.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy_iam.json
}
## Cloudfront setup

locals {
  s3_origin_id = var.s3_bucket.id
}

resource "aws_cloudfront_distribution" "s3_bucket_distribution" {
  origin {
    domain_name = var.s3_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_bucket_distribution_oai.cloudfront_access_identity_path
    }
  }

  enabled             = var.distribution_enable
  is_ipv6_enabled     = var.distribution_ipv6
  comment             = var.distribution_comment
  default_root_object = var.s3_bucket_configuration_index

  dynamic "logging_config" {
    for_each = var.distribution_access_logging_enabled ? ["true"] : []
    content {
      include_cookies = var.distribution_access_log_include_cookies
      bucket          = var.s3_bucket_log.bucket_domain_name
      prefix          = var.distribution_access_log_prefix
    }
  }

  aliases = var.distribution_aliases_enable ? var.distribution_aliases : []

  default_cache_behavior {
    allowed_methods  = var.distribution_default_cache_allowed_methods
    cached_methods   = var.distribution_default_cached_methods
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = var.distribution_default_forwarded_query_string

      cookies {
        forward = var.distribution_default_cookies_forward
      }
    }

    viewer_protocol_policy = var.distribution_default_viewer_protocol
    min_ttl                = var.distribution_default_min_ttl
    default_ttl            = var.distribution_default_ttl
    max_ttl                = var.distribution_default_max_ttl
  }

  price_class = var.distribution_price_class

  dynamic "custom_error_response" {
    for_each = var.distribution_error_response
    content {
      error_caching_min_ttl = custom_error_response.value["error_caching_min_ttl"]
      error_code            = custom_error_response.value["error_code"]
      response_code         = custom_error_response.value["response_code"]
      response_page_path    = custom_error_response.value["response_page_path"]
    }
  }
  dynamic "restrictions" {
    for_each = var.distribution_restriction_type == "none" ? ["true"] : []
    content {
      geo_restriction {
        restriction_type = var.distribution_restriction_type
      }
    }
  }
  dynamic "restrictions" {
    for_each = var.distribution_restriction_type != "none" ? ["true"] : []
    content {
      geo_restriction {
        restriction_type = var.distribution_restriction_type
        locations        = var.distribution_restriction_locations
      }
    }
  }

  tags = var.tags

  viewer_certificate {
    #cloudfront_default_certificate = var.distribution_viewer_certificate
    acm_certificate_arn = var.distribution_acm_certificate
    ssl_support_method  = var.distribution_ssl_support_method
  }
}