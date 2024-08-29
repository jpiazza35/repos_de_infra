# S3 bucket for storing the SQL scripts for RDS
resource "aws_s3_bucket" "sql_automation" {
  bucket = "${var.tags["Environment"]}-${var.tags["Product"]}-sql-scripts-bucket"
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

resource "aws_s3_bucket_policy" "sql_automation" {
  bucket = aws_s3_bucket.sql_automation.id

  policy = data.template_file.s3_access_sql_automation.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.sql_automation
  ]
}

resource "aws_s3_bucket_public_access_block" "sql_automation" {
  bucket = aws_s3_bucket.sql_automation.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "sql_automation" {
  bucket = aws_s3_bucket.sql_automation.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.sql_automation.arn
    events = [
      "s3:ObjectCreated:*"
    ]
    filter_suffix = ".sql"
  }

  depends_on = [aws_lambda_permission.sql_automation]
}