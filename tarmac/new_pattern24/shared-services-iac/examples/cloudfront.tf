module "cloudfront" {
  source      = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//cloudfront?ref=1.0.165"
  alb_name    = "cf-alb"
  app         = "demo"
  env         = "qa"
  domain_name = "cliniciannexus.com"

  cloudfront = [
    {
      enabled             = true
      name                = "demo-qa-cloudfront"
      default_root_object = "index.html" # Object that is CF returns when an end user requests the root URL.

      ## aliases is the same as alternate domain names. This is the actual extra CNAME (domain) to be used,
      ## so make sure it is set correctly. If its value is set here, it will be used as alias. 
      ## If not, then based on the environment the alias will be set - for prod following APP.DOMAIN (e.g. mpt.cliniciannexus.com) and for nonprod APP.ENV.DOMAIN (e.g. mpt.qa.cliniciannexus.com)
      aliases = ["demo.qa.cliniciannexus.com"]

      ## Provide custom error responses (a list of maps)
      custom_error_response = [
        {
          error_caching_min_ttl = 10
          error_code            = 404
          response_code         = 200
          response_page_path    = "/index.html"
        },
        {
          error_caching_min_ttl = 10
          error_code            = 403
          response_code         = 403
          response_page_path    = "/index.html"
        }
      ]
      geo_restriction = {
        restriction_type = "none" # none, whitelist, blacklist
        locations        = []     # if restriction_type is none, then this should be an empty list []. Else, provide valid values.
      }
      logging_config = {
        enabled         = false
        bucket          = "" ## <bucket_name>.s3.amazonaws.com
        include_cookies = false
        prefix          = ""
      }
      http_version = "http2and3" # http1.1, http2, http2and3, http3 - The http_version value that you want CloudFront to use for connections from viewers to CloudFront.
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
        target_origin_id          = "demoS3Origin"
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
        response_headers_policy_id  = "67f7725c-6f97-4210-82d7-5512b31e9d03"
        realtime_log_config_arn     = null
        min_ttl                     = null
        default_ttl                 = null
        max_ttl                     = null
        forwarded_values            = null
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
          domain_name = "mot-654195447.us-east-1.elb.amazonaws.com"
          origin_id   = "mot-654195447.us-east-1.elb.amazonaws.com"
          custom_origin_config = {
            http_port              = 80
            https_port             = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols = [
              "TLSv1.2"
            ]
          }
          s3_origin_config = null
          custom_header = {
            name  = "server-source"
            value = "cloudfront-restricted"
          }
          origin_access_control_id = null
          origin_shield            = null
          ordered_cache_behavior   = null
        },
        {
          ## S3 Origin
          type                     = "s3"
          domain_name              = "qa-ui-test.qa.cliniciannexus.com.s3.us-east-1.amazonaws.com" #bucket_name {bucket-name}.s3.{region}.amazonaws.com. For static sites, use s3 website endpoint {bucket-name}.s3-website-{region}.amazonaws.com
          origin_id                = "demoS3Origin"
          custom_origin_config     = null
          custom_header            = null
          origin_access_control_id = null
          origin_shield            = null

          s3_origin_config = null
          # s3_origin_config = {
          #   origin_access_identity = "create"
          # }
        }
      ]
      origin_group = [
        {
          origin_id = "albGroup"
          failover_criteria = {
            status_codes = [403, 404, 500, 502]
          }
          members = [
            {
              origin_id = "mot-654195447.us-east-1.elb.amazonaws.com"
            }
          ]
        }
      ]

      ordered_cache_behavior = [
        {
          origin_type  = "s3"
          path_pattern = "/api/*"
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
          target_origin_id          = "demoS3Origin"
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

          forwarded_values = null
          origin_request_policy = {
            name    = "demo-qa-cloudfront-s3-orp"
            comment = "demo-qa-cloudfront-s3-orp"
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
        },
        {
          origin_type  = "alb"
          path_pattern = "/swagger/*"
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
          target_origin_id          = "mot-654195447.us-east-1.elb.amazonaws.com"
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
          response_headers_policy_id  = "67f7725c-6f97-4210-82d7-5512b31e9d03"
          realtime_log_config_arn     = null
          min_ttl                     = null
          default_ttl                 = null
          max_ttl                     = null
          forwarded_values            = null
          lambda_function_association = null
          origin_request_policy = {
            name    = "demo-qa-cloudfront-alb-orp"
            comment = "demo-qa-cloudfront-alb-orp"
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

  tags = merge(
    var.tags,
    {
      Name        = "demo-cloudfront"
      Description = "Demo Cloudfront Resources"
      Environment = "qa"
      Domain      = "cliniciannexus.com"
    },
  )

}
