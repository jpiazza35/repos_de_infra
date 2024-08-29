resource "aws_s3_bucket" "s3_conf" {
  bucket = var.s3_bucket_conf
}

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.s3_conf.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "acl_s3" {
  bucket = aws_s3_bucket.s3_conf.id
  acl    = "private"
}

resource "aws_s3_object" "conformance-pack-template" {
  bucket = aws_s3_bucket.s3_conf.id
  key    = "Operational-Best-Practices-for-CIS.yaml"
  source = "${path.module}/conformance_pack/Operational-Best-Practices-for-CIS.yaml"
  etag   = filemd5("${path.module}/conformance_pack/Operational-Best-Practices-for-CIS.yaml")
}

resource "aws_s3_bucket_policy" "config_logging_policy" {
  bucket = aws_s3_bucket.s3_conf.id
  policy = templatefile("${path.module}/policies/config_s3_policy.json", {
    bucket_arn = aws_s3_bucket.s3_conf.arn,
    account_id = data.aws_caller_identity.current.id
  })
}

resource "aws_s3_bucket_public_access_block" "s3_conf" {
  bucket                  = aws_s3_bucket.s3_conf.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
