resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_body = jsonencode(local.dashboard)
  dashboard_name = "${var.env}-${var.app}"
}

resource "aws_cloudwatch_metric_alarm" "httpcode_target_5xx_count" {
  alarm_name          = "${var.env}-${var.app}-TG-high5XXCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Average API 5XX target group error code count is too high"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    "TargetGroup"  = aws_lb_target_group.vault.id
    "LoadBalancer" = var.alb_arn
  }
}

resource "aws_cloudwatch_metric_alarm" "httpcode_lb_5xx_count" {
  alarm_name          = "${var.env}-${var.app}-LB-high5XXCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Average API 5XX load balancer error code count is too high"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    "LoadBalancer" = var.alb_arn
  }
}

resource "aws_cloudwatch_metric_alarm" "target_response_time_average" {
  alarm_name          = "${var.env}-${var.app}-highResponseTime"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Average API response time is too high"
  alarm_actions       = var.actions_alarm
  ok_actions          = var.actions_ok

  dimensions = {
    "TargetGroup"  = aws_lb_target_group.vault.id
    "LoadBalancer" = var.alb_arn
  }
}
