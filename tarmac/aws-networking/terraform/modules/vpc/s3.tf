# Create local logging bucket for account troubleshooters
resource "aws_s3_bucket" "flowlogs" {
  count  = var.name == "primary-vpc" ? 1 : 0
  bucket = format("cn-flow-logs-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name)

  tags = merge(
    var.tags,
    {
      Environment    = "shared_services"
      App            = "tgw"
      Resource       = "Managed by Terraform"
      Description    = "Transit Gateway Configuration"
      Team           = "DevOps"
      "cn:service"   = "storage"
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_policy" "flowlogs" {
  count  = var.name == "primary-vpc" ? 1 : 0
  bucket = aws_s3_bucket.flowlogs[count.index].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.flowlogs[count.index].arn}"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.flowlogs[count.index].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
EOF

}

resource "aws_s3_bucket_public_access_block" "flowlogs" {
  count                   = var.name == "primary-vpc" ? 1 : 0
  bucket                  = aws_s3_bucket.flowlogs[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_ownership_controls" "flowlogs" {
  count  = var.name == "primary-vpc" ? 1 : 0
  bucket = aws_s3_bucket.flowlogs[count.index].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "flowlogs" {
  count      = var.name == "primary-vpc" ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.flowlogs]

  bucket = aws_s3_bucket.flowlogs[count.index].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "flowlogs" {
  count  = var.name == "primary-vpc" ? 1 : 0
  bucket = aws_s3_bucket.flowlogs[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

# Set lifecycle on the local logging bucket
resource "aws_s3_bucket_lifecycle_configuration" "flowlogs" {
  count  = var.name == "primary-vpc" ? 1 : 0
  bucket = aws_s3_bucket.flowlogs[count.index].id

  rule {
    id = "expiration"
    filter {}
    expiration {
      days = 30
    }
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

resource "aws_kms_key" "key" {
  count                   = var.name == "primary-vpc" ? 1 : 0
  description             = "VPC Flow Log Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key[count.index].json

  tags = merge(
    var.tags,
    {
      Environment  = "shared_services"
      App          = "tgw"
      Resource     = "Managed by Terraform"
      Description  = "Transit Gateway Configuration"
      Team         = "DevOps"
      "cn:service" = "security"
    }
  )
}

resource "aws_kms_alias" "alias" {
  count         = var.name == "primary-vpc" ? 1 : 0
  name          = "alias/tgw-flowlogs"
  target_key_id = aws_kms_key.key[count.index].key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "flowlogs" {
  count  = var.name == "primary-vpc" ? 1 : 0
  bucket = aws_s3_bucket.flowlogs[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key[count.index].arn
      sse_algorithm     = "aws:kms"
    }
  }
}
