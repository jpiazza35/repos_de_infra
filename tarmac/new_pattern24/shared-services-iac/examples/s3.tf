module "s3" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//s3?ref=1.0.160"

  ## S3 module variables

  bucket_properties = {
    name                           = "sdlc-data-quality"
    env                            = "sdlc"
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
    kms_key_arn                          = ""
  }

  tags = merge(
    var.tags,
    {
      Environment    = "sdlc"
      App            = "data-quality"
      Resource       = "Managed by Terraform"
      Description    = "Data Quality Service Related Configuration"
      Team           = "DevOps"
      SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    }
  )
}