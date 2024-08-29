resource "aws_s3_bucket" "bucket_config" {
  bucket = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-config-s3"
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
}

resource "aws_s3_bucket_policy" "config_logging_policy" {
  bucket = aws_s3_bucket.bucket_config.bucket
  policy = data.template_file.s3_bucket_config.rendered

}
resource "aws_s3_bucket_public_access_block" "bucket_config" {
  bucket                  = aws_s3_bucket.bucket_config.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "conformancePCIpack" {
  bucket = aws_s3_bucket.bucket_config.bucket
  key    = "Operational-Best-Practices-for-PCI-DSS.yml"
  source = "${path.module}/conformance_packs/Operational-Best-Practices-for-PCI-DSS.yml"
}