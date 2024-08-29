resource "aws_wafv2_web_acl_association" "waf" {
  resource_arn = var.api_gw_arn
  web_acl_arn  = aws_wafv2_web_acl.common_rule_set.arn
}