output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket
}

output "s3_bucket_configuration_index" {
  value = var.s3_bucket_configuration_index
}

output "s3_bucket_log" {
  value = aws_s3_bucket.s3_bucket_log
}