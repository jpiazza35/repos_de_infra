/*
output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket
}

output "s3_bucket_configuration_index" {
  value = var.s3_bucket_configuration_index
}

output "s3_bucket_log" {
  value = aws_s3_bucket.s3_bucket_log
}

output "load_balancer_bucket_log" {
  value = aws_s3_bucket.load_balancer_bucket_log
}

output "s3_bucket_datalake" {
  value = aws_s3_bucket.s3_bucket_datalake
}

output "s3_bucket_scripts" {
  value = aws_s3_bucket.s3_bucket_scripts
}
*/

output "s3_bucket_bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "s3_bucket_bucket_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
}