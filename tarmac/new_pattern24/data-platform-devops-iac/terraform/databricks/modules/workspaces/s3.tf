//Root Bucket
resource "aws_s3_bucket" "root_storage_bucket" {

  bucket        = terraform.workspace == "dev" ? format("%s-rootbucket", local.prefix) : format("cn-%s-rootbucket", local.prefix)
  force_destroy = true
  tags = merge(
    var.tags,
    {
      Name = terraform.workspace == "dev" ? format("%s-rootbucket", local.prefix) : format("cn-%s-rootbucket", local.prefix)
    }
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "root_storage_bucket" {

  bucket = aws_s3_bucket.root_storage_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "root_storage_bucket" {

  bucket = aws_s3_bucket.root_storage_bucket.id
  acl    = "private"
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership
  ]

}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {

  bucket = aws_s3_bucket.root_storage_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "root_storage_bucket" {

  bucket = aws_s3_bucket.root_storage_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

// Ignore public access control lists (ACLs) on the S3 root bucket and on any objects that this bucket contains.
resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {

  bucket              = aws_s3_bucket.root_storage_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  depends_on = [
    aws_s3_bucket.root_storage_bucket
  ]
}

// Attach the access policy to the S3 root bucket within your AWS account.
resource "aws_s3_bucket_policy" "root_bucket_policy" {

  bucket = aws_s3_bucket.root_storage_bucket.id
  policy = data.databricks_aws_bucket_policy.db_bucket_policy.json
  depends_on = [
    aws_s3_bucket_public_access_block.root_storage_bucket
  ]
}
