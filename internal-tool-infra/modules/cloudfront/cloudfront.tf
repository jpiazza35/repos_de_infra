resource "aws_cloudfront_distribution" "internal_tool_distribution" {
  aliases             = var.environment == "dev" ? ["fe-dev.staplerroja.com"] : ["internal-tool.staplerroja.com"]
  default_root_object = "index.html" //var.cloudfront_default_root_object
  enabled             = true
  web_acl_id          = var.web_acl_arn
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  tags                = {}
  tags_all            = {}
  wait_for_deployment = true

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403           //var.cloudfront_error_code
    response_code         = 200           //var.cloudfront_response_code
    response_page_path    = "/index.html" //var.cloudfront_response_page_path
  }
  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = var.environment == "dev" ? "tarmac-internal-tool.s3.us-east-1.amazonaws.com" : "tarmac-internal-tool-prod.s3.us-east-1.amazonaws.com"
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"
  }

  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = var.cloudfront_origin_domain_name
    origin_id                = var.cloudfront_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_frontend.id
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.staplerroja.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "s3_frontend" {
  name                              = var.cloudfront_origin_id
  description                       = "Cloudfornt distribution for S3 forntend"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

