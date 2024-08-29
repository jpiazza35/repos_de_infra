variable "domain_name" {
  type = string
}
variable "env" {}
variable "alb_name" {}
variable "app" {}
variable "tags" {}
variable "cloudfront" {

  type = list(object({
    enabled             = bool
    name                = optional(string)
    aliases             = optional(list(string))
    default_root_object = optional(string)
    http_version        = optional(string)
    custom_error_response = optional(list(object({
      error_caching_min_ttl = optional(number)
      error_code            = number
      response_code         = optional(number)
      response_page_path    = optional(string)
    })))

    geo_restriction = object({
      restriction_type = string
      locations        = list(string)
    })

    logging_config = optional(object({
      enabled         = optional(bool)
      bucket          = string
      include_cookies = bool
      prefix          = string
    }))

    default_cache_behavior = object({
      allowed_methods            = list(string)
      cached_methods             = list(string)
      target_origin_id           = string
      viewer_protocol_policy     = string
      field_level_encryption_id  = optional(string)
      smooth_streaming           = optional(bool)
      trusted_signers            = optional(list(string))
      trusted_key_groups         = optional(list(string))
      cache_policy_id            = optional(string)
      compress                   = optional(bool)
      origin_request_policy_id   = optional(string)
      response_headers_policy_id = optional(string)
      realtime_log_config_arn    = optional(string)
      min_ttl                    = optional(number)
      default_ttl                = optional(number)
      max_ttl                    = optional(number)

      forwarded_values = object({
        headers      = list(string)
        query_string = bool

        cookies = object({
          forward = string
        })
      })

      lambda_function_association = optional(object({
        event_type   = optional(string)
        lambda_arn   = optional(string)
        include_body = optional(string)
      }))

    })

    origin = list(object({
      type        = string
      domain_name = string
      origin_id   = string

      custom_origin_config = optional(object({
        http_port              = optional(number)
        https_port             = optional(number)
        origin_protocol_policy = optional(string)
        origin_ssl_protocols   = optional(list(string))
      }))

      custom_header = optional(object({
        name  = optional(string)
        value = optional(string)
      }))

      s3_origin_config = optional(object({
        origin_access_identity = optional(string)
      }))

      origin_access_control_id = optional(string)

      origin_shield = optional(object({
        enabled              = optional(bool)
        origin_shield_region = optional(string)
      }))

    }))

    ordered_cache_behavior = optional(list(object({
      path_pattern               = optional(string)
      allowed_methods            = optional(list(string))
      cached_methods             = optional(list(string))
      target_origin_id           = optional(string)
      viewer_protocol_policy     = optional(string)
      field_level_encryption_id  = optional(string)
      smooth_streaming           = optional(bool)
      trusted_signers            = optional(list(string))
      trusted_key_groups         = optional(list(string))
      cache_policy_id            = optional(string)
      compress                   = optional(bool)
      origin_request_policy_id   = optional(string)
      response_headers_policy_id = optional(string)
      realtime_log_config_arn    = optional(string)
      min_ttl                    = optional(number)
      default_ttl                = optional(number)
      max_ttl                    = optional(number)

      forwarded_values = optional(object({
        headers                 = optional(list(string))
        query_string            = optional(bool)
        query_string_cache_keys = optional(list(string))
        cookies = optional(object({
          forward = optional(string)
        }))
      }))

      lambda_function_association = optional(object({
        event_type   = optional(string)
        lambda_arn   = optional(string)
        include_body = optional(string)
      }))

      origin_request_policy = object({
        name    = string
        comment = optional(string)
        cookies_config = object({
          cookie_behavior = string
          cookies = optional(object({
            items = optional(list(string))
          }))
        })
        headers_config = object({
          header_behavior = string
          headers = optional(object({
            items = optional(list(string))
          }))
        })
        query_strings_config = object({
          query_string_behavior = string
          query_strings = optional(object({
            items = optional(list(string))
          }))
        })
      })
    })))

    origin_group = optional(list(object({
      origin_id = optional(string)
      failover_criteria = optional(object({
        status_codes = optional(list(number))
      }))
      members = optional(list(object({
        origin_id = optional(string)
      })))
    })))

    origin_access_control = optional(object({
      name                              = optional(string)
      description                       = optional(string)
      origin_access_control_origin_type = optional(string)
      signing_behavior                  = optional(string)
      signing_protocol                  = optional(string)
    }))

  }))

  default = [
    {
      enabled = true
      name    = "cf-distribution"
      aliases = []
      logging_config = {
        enabled         = false
        bucket          = "" ## <bucket_name>.s3.amazonaws.com
        include_cookies = false
        prefix          = ""
      }
      geo_restriction = {
        restriction_type = "none"
        locations        = []
      }
      http_version = "http2"
      default_cache_behavior = {
        allowed_methods = [
          "GET",
          "HEAD",
          "OPTIONS",
          "PUT",
          "POST",
          "PATCH",
          "DELETE"
        ]
        cached_methods = [
          "GET",
          "HEAD",
          "OPTIONS"
        ]
        target_origin_id          = "origin"
        viewer_protocol_policy    = "redirect-to-https"
        compress                  = true
        field_level_encryption_id = null
        smooth_streaming          = null
        trusted_signers           = null
        trusted_key_groups        = null
        cache_policy_id           = null
        origin_request_policy_id  = null
        # This is id for SecurityHeadersPolicy copied from https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
        response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
        realtime_log_config_arn    = null
        min_ttl                    = null
        default_ttl                = null
        max_ttl                    = null
        forwarded_values = {
          headers                 = []
          query_string            = true
          query_string_cache_keys = []
          cookies = {
            forward = "all"
          }
        }
        lambda_function_association = null
        # lambda_function_association = {
        #   event_type   = null
        #   lambda_arn   = null
        #   include_body = false
        # }
      }

      origin = [
        {
          ### ALB Origin
          type        = "alb"
          domain_name = "" # ALB DNS
          origin_id   = "ALBorigin"
          custom_origin_config = {
            http_port              = 80
            https_port             = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols   = []
          }
          s3_origin_config = null
          custom_header = {
            name  = "server-source"
            value = "cloudfront-restricted"
          }
          origin_access_control_id = null
          origin_shield            = null
        },
        {
          ## S3 Origin
          type                     = "s3"
          domain_name              = "" # S3 bucket regional domain name (e.g. demo-bucket.s3.us-east-1.awsamazon.com). Can be fetched via S3 module s3_bucket_regional_domain_name output.
          origin_id                = "s3origin"
          custom_origin_config     = null
          custom_header            = null
          origin_access_control_id = null
          origin_shield            = null

          s3_origin_config = {
            origin_access_identity = "create" ## This will create the OAI for the S3 bucket, if you want to use an existing OAI, use the OAI ID here. This is the OAI ID for the S3 bucket. Entering null will not create an OAI.
          }
        }
      ]


      ordered_cache_behavior = [
        {
          path_pattern = "/*"
          allowed_methods = [
            "GET",
            "HEAD",
            "OPTIONS",
            "PUT",
            "POST",
            "PATCH",
            "DELETE"
          ]
          cached_methods = [
            "GET",
            "HEAD",
            "OPTIONS"
          ]
          target_origin_id          = "origin"
          viewer_protocol_policy    = "redirect-to-https"
          compress                  = true
          field_level_encryption_id = null
          smooth_streaming          = null
          trusted_signers           = null
          trusted_key_groups        = null
          ## https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized-uncompressed
          cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
          origin_request_policy_id = null
          # This is id for SecurityHeadersPolicy copied from https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
          response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
          realtime_log_config_arn    = null
          min_ttl                    = null
          default_ttl                = null
          max_ttl                    = null

          forwarded_values = {
            headers      = []
            query_string = false
            cookies = {
              forward = "none"
            }
          }
          origin_request_policy = {
            name    = "cloudfront-orp"
            comment = "cloudfront-orp"
            cookies_config = {
              cookie_behavior = "none"
              cookies = {
                items = []
              }
            }
            headers_config = {
              header_behavior = "none"
              headers = {
                items = []
              }
            }
            query_strings_config = {
              query_string_behavior = "none"
              query_strings = {
                items = []
              }
            }
          }
        }
      ]
      origin_access_control = {
        name                              = "cloudfront-oac"
        description                       = "Policy restricting access to CloudFront distribution"
        origin_access_control_origin_type = "s3"
        signing_behavior                  = "always"
        signing_protocol                  = "sigv4"
      }
    }
  ]
}
