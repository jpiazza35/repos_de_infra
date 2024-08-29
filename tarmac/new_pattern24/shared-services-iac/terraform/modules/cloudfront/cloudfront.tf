## Create Cloudfront Distribution
resource "aws_cloudfront_distribution" "cf" {
  for_each = {
    for cf in var.cloudfront : cf.name => cf
  }

  enabled             = each.value.enabled
  default_root_object = try(each.value.default_root_object, null)
  aliases             = each.value.aliases == null || try(length(each.value.aliases), []) == 0 ? local.cf_alternate_domains : each.value.aliases
  http_version        = each.value.http_version == null ? "http2" : each.value.http_version

  dynamic "custom_error_response" {
    for_each = try(
      each.value.custom_error_response, []
    )
    content {
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  dynamic "origin" {
    for_each = each.value.origin
    iterator = o
    content {
      domain_name = try(o.value.domain_name, null)
      origin_id   = try(o.value.origin_id, null)

      origin_access_control_id = o.value.type != "s3" ? null : aws_cloudfront_origin_access_control.oac[each.value.origin_access_control.name].id

      dynamic "custom_origin_config" {
        for_each = o.value.custom_origin_config != null ? [o.value.custom_origin_config] : []
        content {
          http_port              = custom_origin_config.value.http_port
          https_port             = custom_origin_config.value.https_port
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols = try(
            custom_origin_config.value.origin_ssl_protocols, ["TLSv1.2"]
          )
        }
      }

      dynamic "custom_header" {
        for_each = o.value.custom_header != null ? [o.value.custom_header] : []

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "s3_origin_config" {
        for_each = o.value.s3_origin_config != null ? o.value.s3_origin_config : {}

        content {
          origin_access_identity = o.value.s3_origin_config.origin_access_identity != null && o.value.s3_origin_config.origin_access_identity == "create" ? try(
            aws_cloudfront_origin_access_identity.oai[o.value.domain_name].cloudfront_access_identity_path, null
          ) : null
        }
      }

      dynamic "origin_shield" {
        for_each = o.value.origin_shield != null ? o.value.origin_shield : {}

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }
    }
  }

  dynamic "origin_group" {
    for_each = each.value.origin_group != null ? each.value.origin_group : []
    iterator = og

    content {
      origin_id = og.value.origin_id

      failover_criteria {
        status_codes = og.value.failover_criteria.status_codes
      }

      dynamic "member" {
        for_each = og.value.members
        content {
          origin_id = member.value.origin_id
        }

      }
    }
  }

  dynamic "default_cache_behavior" {
    for_each = try(
      [
        each.value.default_cache_behavior
    ], [{}])
    iterator = dc
    content {
      allowed_methods           = dc.value.allowed_methods
      cached_methods            = dc.value.cached_methods
      target_origin_id          = dc.value.target_origin_id
      viewer_protocol_policy    = dc.value.viewer_protocol_policy
      compress                  = dc.value.compress
      field_level_encryption_id = dc.value.field_level_encryption_id
      smooth_streaming          = dc.value.smooth_streaming
      trusted_signers           = dc.value.trusted_signers
      trusted_key_groups        = dc.value.trusted_key_groups

      cache_policy_id            = dc.value.cache_policy_id
      origin_request_policy_id   = dc.value.origin_request_policy_id
      response_headers_policy_id = dc.value.response_headers_policy_id
      realtime_log_config_arn    = dc.value.realtime_log_config_arn

      min_ttl     = dc.value.min_ttl
      default_ttl = dc.value.default_ttl
      max_ttl     = dc.value.max_ttl

      dynamic "forwarded_values" {
        for_each = dc.value.forwarded_values != null ? [dc.value.forwarded_values] : []
        iterator = fv
        content {
          headers      = fv.value.headers
          query_string = fv.value.query_string
          dynamic "cookies" {
            for_each = try(
              [fv.value.cookies], [{}]
            )
            content {
              forward = cookies.value.forward
            }
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = dc.value.lambda_function_association != null ? dc.value.lambda_function_association : {}
        content {
          event_type   = try(lfa.value.event_type, null)
          lambda_arn   = try(lfa.value.lambda_arn, null)
          include_body = try(lfa.value.include_body, null)
        }
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = try(
      flatten([
        for ocb in each.value.ordered_cache_behavior : ocb
        if ocb != null
      ]), [{}]
    , [{}])
    iterator = ocb

    content {
      path_pattern              = ocb.value.path_pattern
      allowed_methods           = ocb.value.allowed_methods
      cached_methods            = ocb.value.cached_methods
      target_origin_id          = ocb.value.target_origin_id
      viewer_protocol_policy    = ocb.value.viewer_protocol_policy
      compress                  = ocb.value.compress
      field_level_encryption_id = ocb.value.field_level_encryption_id
      smooth_streaming          = ocb.value.smooth_streaming
      trusted_signers           = ocb.value.trusted_signers
      trusted_key_groups        = ocb.value.trusted_key_groups

      cache_policy_id            = ocb.value.cache_policy_id
      response_headers_policy_id = ocb.value.response_headers_policy_id
      realtime_log_config_arn    = ocb.value.realtime_log_config_arn

      min_ttl     = ocb.value.min_ttl
      default_ttl = ocb.value.default_ttl
      max_ttl     = ocb.value.max_ttl

      origin_request_policy_id = aws_cloudfront_origin_request_policy.orp[ocb.value.origin_request_policy.name].id

      dynamic "forwarded_values" {
        for_each = ocb.value.forwarded_values != null ? [ocb.value.forwarded_values] : []
        iterator = fv
        content {
          headers      = fv.value.headers
          query_string = fv.value.query_string

          dynamic "cookies" {
            for_each = try(
              [fv.value.cookies], [{}]
            )
            content {
              forward = cookies.value.forward
            }
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = try(
          ocb.lambda_function_association, {}
        )
        iterator = lfa
        content {
          event_type   = lfa.value.event_type
          lambda_arn   = lfa.value.lambda_arn
          include_body = lfa.value.include_body
        }
      }
    }
  }

  dynamic "logging_config" {
    for_each = each.value.logging_config.enabled ? try(
      each.value.logging_config, {}
    ) : {}
    iterator = lc
    content {
      bucket          = lc.value.bucket
      include_cookies = lc.value.include_cookies
      prefix          = lc.value.prefix
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = each.value.geo_restriction.restriction_type
      locations        = each.value.geo_restriction.restriction_type == "null" ? [] : each.value.geo_restriction.locations
    }
  }

  tags = var.tags

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.aws_acm_certificate.cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

## Create Cloudfront Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  for_each = {
    for cf in var.cloudfront : cf.origin_access_control.name => cf
  }
  name                              = each.value.origin_access_control.name
  description                       = each.value.origin_access_control.description
  origin_access_control_origin_type = each.value.origin_access_control.origin_access_control_origin_type
  signing_behavior                  = each.value.origin_access_control.signing_behavior
  signing_protocol                  = each.value.origin_access_control.signing_protocol
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  for_each = toset(flatten([
    for cf in var.cloudfront : flatten([
      for o in cf.origin : o.domain_name
      if o.s3_origin_config != null
    ])
  ]))

  comment = "Cloudfront OAI for ${each.value}"
}

resource "aws_cloudfront_origin_request_policy" "orp" {
  for_each = {
    for o in [
      for x in coalesce(flatten(
        [
          for cf in var.cloudfront : flatten([
            for orp in cf.ordered_cache_behavior : orp.origin_request_policy
            if cf.ordered_cache_behavior != null
          ])
        ]
      )) : x
    ] : o.name => o
  }

  name    = each.value.name
  comment = each.value.comment

  cookies_config {
    cookie_behavior = each.value.cookies_config.cookie_behavior
    cookies {
      items = each.value.cookies_config.cookies.items
    }
  }
  headers_config {
    header_behavior = each.value.headers_config.header_behavior
    headers {
      items = each.value.headers_config.headers.items
    }
  }
  query_strings_config {
    query_string_behavior = each.value.query_strings_config.query_string_behavior
    query_strings {
      items = each.value.query_strings_config.query_strings.items
    }
  }
}
