# S3 bucket for storing the truststore.pem cert file needed for the mTLS in 3ds-server API-GW
resource "aws_s3_bucket" "api_gw_truststore" {
  count = var.create_truststore ? 1 : 0

  bucket = "${var.tags["Environment"]}-${var.tags["Product"]}-api-gw-truststore-bucket"
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

resource "aws_s3_bucket_policy" "api_gw_truststore" {
  count  = var.create_truststore ? 1 : 0
  bucket = aws_s3_bucket.api_gw_truststore[0].id

  policy = data.template_file.truststore_vpc_endpoint.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.api_gw_truststore
  ]
}

resource "aws_s3_bucket_public_access_block" "api_gw_truststore" {
  count = var.create_truststore ? 1 : 0

  bucket = aws_s3_bucket.api_gw_truststore[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for storing the ALB logs
resource "aws_s3_bucket" "alb_logs" {
  count = var.create_lb_resources ? 1 : 0

  bucket = "${var.tags["Environment"]}-${var.tags["Product"]}-alb-logs-bucket"
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

resource "aws_s3_bucket_policy" "alb_logs" {
  count  = var.create_lb_resources ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[0].id

  policy = data.template_file.alb_logs.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.alb_logs
  ]
}

resource "aws_s3_bucket_public_access_block" "alb_logs" {
  count = var.create_lb_resources ? 1 : 0

  bucket = aws_s3_bucket.alb_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "alb_logs" {
  count  = var.create_lb_resources ? 1 : 0
  bucket = aws_s3_bucket.alb_logs[count.index].id
  acl    = "private"
  key    = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-alb/"
}

# S3 bucket for storing the NLB logs
resource "aws_s3_bucket" "nlb_logs" {
  count = var.create_lb_resources ? 1 : 0

  bucket = "${var.tags["Environment"]}-${var.tags["Product"]}-nlb-logs-bucket"
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

resource "aws_s3_bucket_policy" "nlb_logs" {
  count  = var.create_lb_resources ? 1 : 0
  bucket = aws_s3_bucket.nlb_logs[0].id

  policy = data.template_file.nlb_logs.rendered

  depends_on = [
    aws_s3_bucket_public_access_block.nlb_logs
  ]
}

resource "aws_s3_bucket_public_access_block" "nlb_logs" {
  count = var.create_lb_resources ? 1 : 0

  bucket = aws_s3_bucket.nlb_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "nlb_logs" {
  count  = var.create_lb_resources ? 1 : 0
  bucket = aws_s3_bucket.nlb_logs[count.index].id
  acl    = "private"
  key    = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-nlb/"
}