# #S3 bucket used for Cloud Trail Logging for SSO failed login
# resource "aws_s3_bucket" "s3_sso_failed_login_cloudtrail" {
#   count  = var.sso_failed_login_cloudtrail ? 1 : 0
#   bucket = "${var.tags["Environment"]}-sso-failed-login-cloudtrail-logs"
#   acl    = "private"

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         kms_master_key_id = var.s3_kms_key_alias
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }

#   versioning {
#     enabled = true
#   }

#   tags = var.tags
# }

# resource "aws_s3_bucket_policy" "s3_sso_failed_login_cloudtrail" {
#   count  = var.sso_failed_login_cloudtrail ? 1 : 0
#   bucket = element(concat(aws_s3_bucket.s3_sso_failed_login_cloudtrail.*.id, tolist([""])), 0)

#   policy = templatefile("${path.module}/iam_policies/s3_cloudtrail_logs.json", {
#     aws_account_id = data.aws_caller_identity.current.account_id,
#     s3_trail_logs  = element(concat(aws_s3_bucket.s3_sso_failed_login_cloudtrail.*.arn, tolist([""])), 0)
#   })

#   depends_on = [
#     aws_s3_bucket_public_access_block.s3_sso_failed_login_cloudtrail
#   ]
# }

# resource "aws_s3_bucket_public_access_block" "s3_sso_failed_login_cloudtrail" {
#   count  = var.sso_failed_login_cloudtrail ? 1 : 0
#   bucket = element(concat(aws_s3_bucket.s3_sso_failed_login_cloudtrail.*.id, tolist([""])), 0)

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }