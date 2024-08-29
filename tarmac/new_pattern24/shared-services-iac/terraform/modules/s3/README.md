### S3 Module
To use this module, there are a couple of options:
1. Create a ENV.tfvars files in your root module when declaring it and populate values like that
2. Populate variable values directly when calling the module.

Examples below:

tfvars example file:
=============

```bash
app        = "data-quality"
aws_region = "us-east-1"
dns_name   = "cliniciannexus.com"
env        = "sdlc"

## S3 module variables

s3_buckets = {
  data_quality_service = {
    name                           = "sdlc-data-quality"     # Bucket name used only if enable_website_configuration is set to false. Used like env-name-region e.g. us-east-1-sdlc-data-quality-sdlc                         
    env                            = "sdlc"                  # Used in S3 bucket name only if enable_website_configuration is set to false. Used like env-name-region e.g. us-east-1-sdlc-data-quality-sdlc        
    region                         = "us-east-1"             # Used in S3 bucket name only if enable_website_configuration is set to false. Used like env-name-region e.g. us-east-1-sdlc-data-quality-sdlc
    s3_website_dns_record          = "data-quality"          # This value should be set in case S3 website configuration is used. This will be then used to name the S3 bucket to follow a WEBSITE_DNS_RECORD.WEBSITE_DOMAIN_NAME naming.
    s3_website_domain              = "cliniciannexus.com"    # The main domain of which an S3 website configured bucket will be named.
    enable_acl                     = false                   # true | false - Wheter s3 bucket acl resource is created or not.
    acl                            = "private"               # private | public-read | public-read-write | aws-exec-read | authenticated-read | bucket-owner-read | bucket-owner-full-control | log-deliver-write. Check https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl
    enable_website_configuration   = true                    # true | false - If set to true, S3 website config will be created and bucket will be named using s3_website_dns_record.s3_website_domain naming convention.
    index_document_file            = "index.html"   # The index document file. E.g. index.html, index.php etc.
    error_document_file            = "error.html"   # The index document file. E.g. error.html etc.
    enable_versioning              = true           # true | false - Whether to enable S3 bucket versioning.
    versioning_configuration       = "Enabled"      # Enabled | Disabled | Suspended - Versioning state of the bucket.
    enable_lifecycle_configuration = true           # true | false - Whether to enable the S3 lifecycle config.
    lifecycle_id                   = "expire-noncurrent-versions"   # Unique identifier for the lifecycle rule. The value cannot be longer than 255 characters.
    lifecycle_status               = "Enabled"                      # Enabled | Disabled - Whether the lifecycle rule is applied or not.
    expiration = {         # Block for enabling current object versions expiration. Note: careful when using this as this will enable expiration of all objects in an S3 bucket, deleting files after the days set.
      enabled = false      # false | true - Whether to enable current object versions expiration.
      days    = null       # number - Number of days after current versions of objects in S3 bucket are expired (removed).
    }
    lifecycle_noncurrent_expiration_days = 1          # Number of days after which noncurrent versions of objects are removed from an S3 bucket.
    lifecycle_incomplete_multipart_days  = 1          # Number of days after which Amazon S3 aborts an incomplete multipart upload.
    sse_algorithm                        = "AES256"   # AES256 | aws:kms | aws:kms:dsse - The SSE algorithm used for encryption. Defaults to AES256 (SSE-S3) if not set otherwise.
    kms_key_arn                          = ""         # The KMS key arn if aws:kms is used as SSE algorithm. AWS managed or CMK key can be provided.
  }
}

tags = {
  Environment = "sdlc"
}
```

Module example using the tfvars approach:
=============

```bash
module "s3" {
  source   = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//s3?ref=1.0.160"
  for_each = var.s3_buckets

  bucket_properties = each.value

  tags = merge(
    var.tags,
    {
      Environment    = each.value.env
      App            = var.app
      Resource       = "Managed by Terraform"
      Description    = ""
      Team           = ""
      SourceCodeRepo = ""
    }
  )
}
```

Example of declaring values within the module itself:
=============

```bash
module "s3" {
  source   = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//s3?ref=1.0.160"

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
```
