output "cloudtrail_kms_key_id" {
  value = aws_kms_key.cloudtrail_kms_key.*.key_id
}

output "cloudtrail_kms_key_arn" {
  value = aws_kms_key.cloudtrail_kms_key.*.arn
}

output "cw_log_groups_kms_key_id" {
  value = aws_kms_key.cw_log_groups_kms_key.*.key_id
}

output "cw_log_groups_kms_key_arn" {
  value = aws_kms_key.cw_log_groups_kms_key.*.arn
}

output "s3_kms_key_arn" {
  value = aws_kms_key.s3_kms_key.*.arn
}

output "s3_kms_key_alias" {
  value = element(aws_kms_alias.s3_kms_key.*.name, 0)
}

output "sns_kms_key_alias" {
  value = element(aws_kms_alias.sns_kms_key.*.name, 0)
}