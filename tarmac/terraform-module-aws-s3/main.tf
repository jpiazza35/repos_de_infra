resource "aws_s3_bucket" "s3" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "s3" {
  count  = var.create_bucket_acl ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3" {
  count  = var.create_bucket_encryption ? 1 : 0
  bucket = aws_s3_bucket.s3.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.use_cmk_kms_key ? var.cmk_kms_key_arn : null
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3" {
  count                   = var.create_bucket_block_public_access ? 1 : 0
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "s3" {
  count  = var.create_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.s3.id
  policy = var.bucket_policy_document
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  count  = var.create_bucket_versioning ? 1 : 0
  bucket = aws_s3_bucket.s3.id

  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_website_configuration" "s3" {
  count  = var.create_bucket_website ? 1 : 0
  bucket = aws_s3_bucket.s3.bucket

  index_document {
    suffix = var.index_document_file
  }

  error_document {
    key = var.error_document_file
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3" {
  count  = var.create_bucket_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.s3.id

  rule {
    id     = var.bucket_lifecycle_id
    status = var.bucket_lifecycle_status

    expiration {
      days = var.bucket_lifecycle_expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.bucket_lifecycle_noncurrent_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.bucket_lifecycle_incomplete_multipart_days
    }
  }
}
