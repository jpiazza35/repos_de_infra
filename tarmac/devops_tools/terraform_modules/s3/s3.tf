# S3 bucket for Dashboard Vault
resource "aws_s3_bucket" "dashboard_vault" {
  count  = var.create_dashboard_vault_bucket ? 1 : 0
  bucket = "${var.tags["Moniker"]}-${var.tags["Product"]}-${var.tags["Application"]}-${var.tags["Service"]}-s3-${var.tags["Environment"]}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.s3_kms_key_alias
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "remove-files-older-than-${var.retention_in_days}-days"
    enabled = true

    expiration {
      days = var.retention_in_days
    }

    noncurrent_version_expiration {
      days = 1
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "dashboard_vault" {
  count  = var.create_dashboard_vault_bucket ? 1 : 0
  bucket = element(concat(aws_s3_bucket.dashboard_vault.*.id, tolist([""])), 0)

  policy = var.prod_doc_vault_s3_bucket_policy ? data.template_file.s3_access_dashboard_vault_prod.rendered : data.template_file.s3_access_dashboard_vault.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.dashboard_vault
  ]
}

resource "aws_s3_bucket_public_access_block" "dashboard_vault" {
  count  = var.create_dashboard_vault_bucket ? 1 : 0
  bucket = element(concat(aws_s3_bucket.dashboard_vault.*.id, tolist([""])), 0)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
