output "domain_name" {
  value = values(aws_cloudfront_distribution.cf)[*].domain_name
}

output "distribution_arn" {
  value = values(aws_cloudfront_distribution.cf)[*].arn
}
