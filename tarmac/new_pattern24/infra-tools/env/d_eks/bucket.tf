#1 -this will create a S3 bucket in AWS
resource "aws_s3_bucket" "terraform_state_mpt_app" {
  #make sure you give unique bucket name
  bucket = "terraform-state-${var.aws_region}-${data.aws_caller_identity.current.account_id}"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform_state_mpt_app.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_mpt_app" {
  bucket = aws_s3_bucket.terraform_state_mpt_app.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# 2 - this Creates Dynamo Table
resource "aws_dynamodb_table" "terraform_locks" {
  # Give unique name for dynamo table name
  #dyndb-terraform-locks-us-east-1
  name         = "dyndb-terraform-locks-${var.aws_region}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

