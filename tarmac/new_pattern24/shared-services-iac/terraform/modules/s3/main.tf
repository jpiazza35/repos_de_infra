resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_properties.enable_website_configuration ? "${try(var.bucket_properties.s3_website_dns_record, var.bucket_properties.name)}.${local.s3_website_domain}" : "${var.bucket_properties.env}-${var.bucket_properties.name}-${var.bucket_properties.region}"

  tags = var.tags
}

resource "aws_s3_bucket_acl" "s3" {
  count  = var.bucket_properties.enable_acl ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  acl    = var.bucket_properties.acl == "" || var.bucket_properties.acl == null ? "private" : var.bucket_properties.acl
}

resource "aws_s3_bucket_website_configuration" "s3" {
  count  = var.bucket_properties.enable_website_configuration ? 1 : 0
  bucket = aws_s3_bucket.s3.bucket

  index_document {
    suffix = var.bucket_properties.index_document_file == "" || var.bucket_properties.index_document_file == null ? "index.html" : var.bucket_properties.index_document_file
  }

  error_document {
    key = var.bucket_properties.error_document_file == "" || var.bucket_properties.error_document_file == null ? "error.html" : var.bucket_properties.error_document_file
  }
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "s3" {
  count  = var.bucket_properties.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.s3.id

  versioning_configuration {
    status = var.bucket_properties.versioning_configuration == "" || var.bucket_properties.versioning_configuration == null ? "Enabled" : var.bucket_properties.versioning_configuration
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3" {
  count  = var.bucket_properties.enable_lifecycle_configuration ? 1 : 0
  bucket = aws_s3_bucket.s3.id

  rule {
    id     = var.bucket_properties.lifecycle_id
    status = var.bucket_properties.lifecycle_status

    dynamic "expiration" {
      for_each = var.bucket_properties.expiration.enabled ? { "enabled" = var.bucket_properties.expiration } : {}
      content {
        days = expiration.value.days
      }
    }

    noncurrent_version_expiration {
      noncurrent_days = var.bucket_properties.lifecycle_noncurrent_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.bucket_properties.lifecycle_incomplete_multipart_days
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3" {
  bucket = aws_s3_bucket.s3.bucket

  rule {
    bucket_key_enabled = true
    dynamic "apply_server_side_encryption_by_default" {
      for_each = [1]

      content {
        sse_algorithm     = var.bucket_properties.sse_algorithm == "aws:kms" ? "aws:kms" : "AES256"
        kms_master_key_id = var.bucket_properties.sse_algorithm == "aws:kms" ? coalesce(var.bucket_properties.kms_key_arn, data.aws_kms_key.key.arn) : null
      }
    }
  }
}
