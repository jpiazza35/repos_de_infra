output "s3_bucket_arn" {
  value = aws_s3_bucket.s3.arn
}

output "s3_bucket_id" {
  value = aws_s3_bucket.s3.id
}

output "s3_bucket_domain_name" {
  value = aws_s3_bucket.s3.bucket_domain_name
}

output "s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.s3.bucket_regional_domain_name
}

# S3 Website endpoint that should be used in Cloudfront Origin
output "s3_website_endpoint" {
  value = try(aws_s3_bucket_website_configuration.s3[0].website_endpoint, "")
}