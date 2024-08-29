output "bucket_name" {
  value = aws_s3_bucket.s3.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.s3.arn
}

output "kms_key_arn" {
  value = aws_kms_key.s3_kms.arn
}
