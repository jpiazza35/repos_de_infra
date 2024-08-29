app        = "data-quality"
aws_region = "us-east-1"
dns_name   = "cliniciannexus.com"
env        = "preview"

## S3 module variables

s3_buckets = {
  data_quality_service = {
    name                           = "data-quality"
    env                            = "preview"
    region                         = "us-east-1"
    s3_website_dns_record          = "data-quality"
    s3_website_domain              = "cliniciannexus.com"
    enable_acl                     = false
    acl                            = "private"
    enable_website_configuration   = true
    index_document_file            = "index.html"
    error_document_file            = "error.html"
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

tags = {
  Environment = "preview"
}
