# S3 bucket used for pipeline artifacts
resource "aws_s3_bucket" "s3_code_pipeline" {
  bucket = "${var.tags["Environment"]}-${var.tags["Application"]}-code-pipeline"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "s3_code_pipeline" {
  bucket = aws_s3_bucket.s3_code_pipeline.id

  policy = data.template_file.s3_access_code_pipeline.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.s3_code_pipeline
  ]
}
resource "aws_s3_bucket_public_access_block" "s3_code_pipeline" {
  bucket = aws_s3_bucket.s3_code_pipeline.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# S3 bucket used for pipeline source stage
resource "aws_s3_bucket" "s3_pipeline_source" {
  bucket = "${var.tags["Environment"]}-${var.tags["Application"]}-pipeline-source"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "s3_pipeline_source" {
  bucket = aws_s3_bucket.s3_pipeline_source.id

  policy = data.template_file.s3_access_pipeline_source.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.s3_pipeline_source
  ]
}

resource "aws_s3_bucket_public_access_block" "s3_pipeline_source" {
  bucket = aws_s3_bucket.s3_pipeline_source.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#S3 bucket used for Cloud Trail Logging
resource "aws_s3_bucket" "s3_cloud_trail_logs" {
  count  = var.create_pipeline_trail ? 1 : 0
  bucket = "${var.tags["Environment"]}-${var.tags["Product"]}-pipeline-trail-logs"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "s3_cloud_trail_logs" {
  count  = var.create_pipeline_trail ? 1 : 0
  bucket = element(concat(aws_s3_bucket.s3_cloud_trail_logs.*.id, tolist([""])), 0)

  policy = data.template_file.s3_access_trail_logs.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.s3_cloud_trail_logs
  ]
}

resource "aws_s3_bucket_public_access_block" "s3_cloud_trail_logs" {
  count  = var.create_pipeline_trail ? 1 : 0
  bucket = aws_s3_bucket.s3_cloud_trail_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}