#S3 bucket used for Cloud Trail Logging for OpenSearch
resource "aws_s3_bucket" "s3_cloud_trail_logs" {
  count  = var.send_cloudtrail_logs ? 1 : 0
  bucket = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-cloudtrail-logs"
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

  tags = var.tags
}

resource "aws_s3_bucket_policy" "s3_cloud_trail_logs" {
  count  = var.send_cloudtrail_logs ? 1 : 0
  bucket = element(concat(aws_s3_bucket.s3_cloud_trail_logs.*.id, tolist([""])), 0)

  policy = data.template_file.s3_access_trail_logs.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.s3_cloud_trail_logs
  ]
}

resource "aws_s3_bucket_public_access_block" "s3_cloud_trail_logs" {
  count  = var.send_cloudtrail_logs ? 1 : 0
  bucket = element(concat(aws_s3_bucket.s3_cloud_trail_logs.*.id, tolist([""])), 0)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}