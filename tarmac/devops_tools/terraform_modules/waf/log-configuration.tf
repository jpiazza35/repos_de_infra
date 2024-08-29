resource "aws_wafv2_web_acl_logging_configuration" "wafv2_log_config" {
  # The Amazon Resource Names (ARNs) of the logging destinations that you want to associate with the web ACL.
  log_destination_configs = [
    "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.waf_log_group[0].name}"
  ]

  # The Amazon Resource Name (ARN) of the web ACL that you want to associate with LogDestinationConfigs.
  resource_arn = aws_wafv2_web_acl.common_rule_set.arn

  logging_filter {
    # Default handling for logs that don't match any of the specified filtering conditions.
    default_behavior = "DROP"

    filter {
      # How to handle logs that satisfy the filter's conditions and requirement.
      behavior = "KEEP"

      condition {
        action_condition {
          action = "BLOCK"
        }
      }

      requirement = "MEETS_ALL"
    }
  }
}
