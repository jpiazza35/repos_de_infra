output "kms_key" {
  value = aws_kms_key.key[0].id
}

output "kms_key_arn" {
  value = aws_kms_key.key[0].arn
}
