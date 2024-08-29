output "wafv2_web_acl_regional_arn" {
  description = "ARN of web acl - regional."
  value       = aws_wafv2_web_acl.common_rule_set_regional.arn
}
output "wafv2_web_acl_cloudfront_arn" {
  description = "ARN of web acl - cloudfront."
  value       = aws_wafv2_web_acl.common_rule_set_cloudfront.arn
}