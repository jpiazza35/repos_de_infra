
output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.internal_tool_distribution.arn
}

output "aws_acm_certificate_arn" {
  value = aws_acm_certificate.staplerroja.arn
}