resource "aws_s3_bucket" "state" {
  count  = local.default
  bucket = var.bucket_name
  tags   = local.standard_tags
}

resource "aws_s3_bucket_acl" "acl" {
  count  = local.default
  bucket = aws_s3_bucket.state[count.index].id
  acl    = "private"
}
