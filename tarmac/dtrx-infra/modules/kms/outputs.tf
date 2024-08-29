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

output "sqs_kms_key_id" {
  value = aws_kms_key.sqs_kms_key.*.key_id
}

output "sqs_kms_key_arn" {
  value = aws_kms_key.sqs_kms_key.*.arn
}

output "sqs_kms_key_alias" {
  value = aws_kms_alias.sqs_kms_key.*.name
}