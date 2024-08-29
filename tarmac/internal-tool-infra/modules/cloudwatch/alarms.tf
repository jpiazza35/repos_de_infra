resource "aws_cloudwatch_metric_alarm" "ecs_alarm" {
  for_each = {
    for metric in local.ecs_alarm_config : "${metric.alarm_cluster_name}-${metric.alarm_metric_name}" => metric
  }

  alarm_name        = each.value.alarm_name
  alarm_description = each.value.alarm_description

  namespace           = each.value.alarm_namespace
  metric_name         = each.value.alarm_metric_name
  statistic           = each.value.alarm_metric_statistic
  period              = each.value.alarm_metric_period
  threshold           = each.value.alarm_threshold
  evaluation_periods  = each.value.alarm_metric_evaluation_period
  comparison_operator = each.value.alarm_comparison_operator
  datapoints_to_alarm = each.value.alarm_datapoints_to_alarm

  dimensions = {
    ServiceName = each.value.alarm_service_name
    ClusterName = each.value.alarm_cluster_name
  }

  actions_enabled = length(var.sns_topic_notifications) > 0
  alarm_actions   = var.sns_topic_notifications
  ok_actions      = var.sns_topic_notifications
}
resource "aws_cloudwatch_metric_alarm" "RDS" {
  alarm_name          = "RDS-Above 80%"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "3"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  period              = "300"
  namespace           = "AWS/RDS"
  statistic           = "Average"
  threshold           = "80"
  alarm_actions       = var.sns_topic_notifications
}

resource "aws_cloudwatch_metric_alarm" "EcsTaskExecutionAlarm" {
  alarm_name          = "EcsTaskExecutionAlarm-dev"
  alarm_description   = "ECS Task Execution Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = "5"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  period              = "60"
  namespace           = "AWS/ECS"
  statistic           = "SampleCount"
  threshold           = "5"
  alarm_actions       = var.sns_topic_notifications
  ok_actions          = var.sns_topic_notifications

  dimensions = {
    ClusterName = "dev-default-ecs"
    ServiceName = "internaltool"
  }
}
resource "aws_cloudwatch_metric_alarm" "Elb-5xx" {
  alarm_name          = "ELB 5xx Alarm >= 1"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "1"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  period              = "300"
  namespace           = "AWS/ApplicationELB"
  statistic           = "Average"
  threshold           = "1"
  alarm_actions       = var.sns_topic_notifications
  tags_all            = {}
  ok_actions          = []

  insufficient_data_actions = []

  dimensions = {
    LoadBalancer = "app/dev-ecs-public-lb/ad95cb6ffb6e8912"
  }
}
