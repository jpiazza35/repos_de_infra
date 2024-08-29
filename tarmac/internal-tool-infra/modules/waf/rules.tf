resource "aws_wafv2_web_acl" "common_rule_set_regional" {
  name        = "${var.tags["Environment"]}-${var.tags["Name"]}-web-acl-regional"
  description = "Rules that are generally applicable to web applications."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.properties.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority
      override_action {
        count {}
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_group_statement_name
          vendor_name = rule.value.managed_rule_group_statement_vendor_name
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = rule.value.sampled_requests_enabled
      }
    }
  }
  tags = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.tags["Environment"]}-${var.tags["Name"]}-web-acl-metric"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl" "common_rule_set_cloudfront" {
  name        = "${var.tags["Environment"]}-${var.tags["Name"]}-web-acl-cloudfront"
  description = "Rules that are generally applicable to web applications."
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.properties.rules
    content {
      name     = rule.value.name
      priority = rule.value.priority
      override_action {
        count {}
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.managed_rule_group_statement_name
          vendor_name = rule.value.managed_rule_group_statement_vendor_name
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = rule.value.sampled_requests_enabled
      }
    }
  }
  tags = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.tags["Environment"]}-${var.tags["Name"]}-web-acl-metric"
    sampled_requests_enabled   = true
  }
}
