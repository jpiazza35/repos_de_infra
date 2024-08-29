output "s3_bucket_distribution" {
  value = aws_cloudfront_distribution.s3_bucket_distribution
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_bucket_distribution.domain_name
}