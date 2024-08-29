# resource "aws_iam_role" "cloudtrail_cw_logs" {
#   count = var.sso_failed_login_cloudtrail ? 1 : 0
#   name  = "${var.tags["Environment"]}-cloudtrail-cw-logs-role"
#   path  = "/"

#   assume_role_policy = templatefile("${path.module}/iam_policies/assume_cloudtrail.json", {})
# }

# resource "aws_iam_policy" "cloudtrail_cw_logs" {
#   count       = var.sso_failed_login_cloudtrail ? 1 : 0
#   name        = "${var.tags["Environment"]}-cloudtrail-cw-logs-policy"
#   description = "This policy gives Cloudtrail IAM role permissions to write to Cloudwatch."
#   path        = "/"
#   policy = templatefile("${path.module}/iam_policies/cloudtrail_cw_logs.json", {
#     aws_account_id    = data.aws_caller_identity.current.account_id
#     region            = var.region,
#     cw_log_group_name = element(concat(aws_cloudwatch_log_group.sso_failed_cloud_trail_logs.*.name, tolist([""])), 0)
#   })

#   tags = var.tags
# }

# resource "aws_iam_role_policy_attachment" "cloudtrail_cw_logs" {
#   count      = var.sso_failed_login_cloudtrail ? 1 : 0
#   role       = element(concat(aws_iam_role.cloudtrail_cw_logs.*.name, tolist([""])), 0)
#   policy_arn = element(concat(aws_iam_policy.cloudtrail_cw_logs.*.arn, tolist([""])), 0)
# }

# resource "aws_cloudtrail" "sso_failed_login_trail" {
#   count                         = var.sso_failed_login_cloudtrail ? 1 : 0
#   name                          = "${var.tags["Environment"]}-sso-failed-login-logs"
#   s3_bucket_name                = element(concat(aws_s3_bucket.s3_sso_failed_login_cloudtrail.*.id, tolist([""])), 0)
#   include_global_service_events = false
#   cloud_watch_logs_group_arn    = "${element(concat(aws_cloudwatch_log_group.sso_failed_cloud_trail_logs.*.arn, tolist([""])), 0)}:*"
#   cloud_watch_logs_role_arn     = element(concat(aws_iam_role.cloudtrail_cw_logs.*.arn, tolist([""])), 0)
#   enable_log_file_validation    = true

#   event_selector {
#     read_write_type           = "All"
#     include_management_events = true
#   }

#   kms_key_id = var.cloudtrail_kms_key_arn

#   depends_on = [
#     aws_s3_bucket_policy.s3_sso_failed_login_cloudtrail,
#     aws_s3_bucket.s3_sso_failed_login_cloudtrail
#   ]
# }