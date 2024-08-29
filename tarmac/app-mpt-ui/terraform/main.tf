module "s3" {
  source   = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//s3?ref=1.0.188"
  for_each = { for idx, val in var.s3_buckets : "${val.name}-${val.env}-${val.region}" => val }

  bucket_properties = each.value

  tags = merge(
    var.tags,
    {
      Environment = each.value.env
    }
  )
}

module "cloudfront" {
  source   = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//cloudfront?ref=1.0.188"
  for_each = { for idx, val in var.s3_buckets : "${val.name}-${val.env}-${val.region}" => val }

  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }

  alb_name    = var.alb_name
  app         = var.app
  env         = each.value.env
  domain_name = each.value.s3_website_domain

  cloudfront = [
    {
      enabled             = true
      name                = "${each.value.env}-${var.app}"
      default_root_object = "index.html" # Object that is CF returns when an end user requests the root URL.
      aliases             = null         # Set to null in order to fallback to the Cloudfront module setting the alias/extra CNAME.
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
        restriction_type = "none"
        locations        = []
      }
      logging_config = {
        enabled         = false
        bucket          = "" ## <bucket_name>.s3.amazonaws.com
        include_cookies = false
        prefix          = ""
      }
      http_version = "http2and3"
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
        target_origin_id       = "${each.value.env}-${var.app}-S3Origin"
        viewer_protocol_policy = "redirect-to-https"
        compress               = true
        ## https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized-uncompressed
        cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
        # This is id for SecurityHeadersPolicy copied from https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
        response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
        forwarded_values           = null
      }

      origin = [
        {
          ### S3 Origin
          type        = "s3"
          domain_name = module.s3[each.key].s3_bucket_regional_domain_name
          origin_id   = "${each.value.env}-${var.app}-S3Origin"
        }
      ]

      ordered_cache_behavior = []

      origin_access_control = {
        name                              = "${each.value.env}-${var.app}-cloudfront-oac"
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
      Name        = "${each.value.env}-${var.app}"
      Description = "MPT UI Cloudfront Resources"
      Environment = each.value.env
      Domain      = each.value.s3_website_domain
    },
  )

}

resource "aws_s3_bucket_policy" "s3" {
  for_each = { for idx, val in var.s3_buckets : "${val.name}-${val.env}-${val.region}" => val }

  bucket = local.s3_cf_map[each.key].s3_bucket_id

  policy = templatefile("${path.module}/templates/s3_bucket_policy.json",
    {
      bucket_name    = local.s3_cf_map[each.key].s3_bucket_id
      cloudfront_arn = local.s3_cf_map[each.key].cloudfront_arn
  })
}
