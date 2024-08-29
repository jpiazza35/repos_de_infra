s3_buckets = {
  mpt_ui = {
    name                           = "app-mpt-ui"
    env                            = "prod"
    region                         = "us-east-1"
    s3_website_dns_record          = null
    s3_website_domain              = "cliniciannexus.com"
    enable_acl                     = false
    acl                            = "private"
    enable_website_configuration   = false # Per AWS docs when using OAC, S3 website must not be enabled.
    index_document_file            = "index.html"
    error_document_file            = "index.html"
    enable_versioning              = true
    versioning_configuration       = "Enabled"
    enable_lifecycle_configuration = true
    lifecycle_id                   = "expire-noncurrent-versions"
    lifecycle_status               = "Enabled"
    expiration = {
      enabled = false
      days    = null
    }
    lifecycle_noncurrent_expiration_days = 1
    lifecycle_incomplete_multipart_days  = 1
    sse_algorithm                        = "AES256"
  },
  mpt_ui_preview = {
    name                           = "app-mpt-ui"
    env                            = "preview"
    region                         = "us-east-1"
    s3_website_dns_record          = null
    s3_website_domain              = "cliniciannexus.com"
    enable_acl                     = false
    acl                            = "private"
    enable_website_configuration   = false # Per AWS docs when using OAC, S3 website must not be enabled.
    index_document_file            = "index.html"
    error_document_file            = "index.html"
    enable_versioning              = true
    versioning_configuration       = "Enabled"
    enable_lifecycle_configuration = true
    lifecycle_id                   = "expire-noncurrent-versions"
    lifecycle_status               = "Enabled"
    expiration = {
      enabled = false
      days    = null
    }
    lifecycle_noncurrent_expiration_days = 1
    lifecycle_incomplete_multipart_days  = 1
    sse_algorithm                        = "AES256"
  }
}

aws_region = "us-east-1"
app        = "mpt"
