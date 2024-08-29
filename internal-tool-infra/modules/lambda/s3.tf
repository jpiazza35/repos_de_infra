resource "aws_s3_bucket" "dependencies_store" {
  bucket = local.s3_bucket_dependency_name

  tags = {
    environment : var.lambda_environment
    project : var.lambda_project
    name : local.s3_bucket_dependency_name
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.dependencies_store.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_encryption" {
  bucket = aws_s3_bucket.dependencies_store.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket = aws_s3_bucket.dependencies_store.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# Note about source/source_hash properties and filemd5 Terraform function:
# During a normal operation, the filemd5 Terraform function needs that the file used as a parameter
# must be already present since the terraform functions are processed before the graph calculations.
# Thus, the source/source_hash properties point to the same file. In this particular scenario, both,
# the function and the source/source_hash properties are pointing to a different file since the zip
# file lambda-dependencies.zip is created during the execution and is not present beforehand.
resource "aws_s3_object" "dependency_file_upload" {
  bucket      = aws_s3_bucket.dependencies_store.id
  key         = local.dependency_file_name
  source      = "${path.module}/scripts/dependencies/lambda-dependencies.zip"
  source_hash = filemd5(data.archive_file.source.source_file)
  depends_on  = [data.archive_file.source]
}
