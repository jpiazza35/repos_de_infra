output "bucket_name" {
  value = aws_s3_bucket.s3.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.s3.arn
}

output "kms_key_arn" {
  value = aws_kms_key.s3_kms.arn
}

output "bucket_id" {
  value = aws_s3_bucket.s3.id
}

output "kms_key_id" {
  value = aws_kms_key.s3_kms.id
}
