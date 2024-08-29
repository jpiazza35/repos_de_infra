resource "aws_cloudwatch_log_group" "ecs" {
  name              = var.is_example_server ? "ecs/${var.tags["Environment"]}-${var.tags["Application"]}-shared-log-group" : "ecs/${var.tags["Environment"]}-${var.tags["Application"]}-log-group"
  kms_key_id        = var.cw_log_groups_kms_key_arn
  retention_in_days = var.cw_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  count               = var.create_cw_metric ? 1 : 0
  alarm_name          = var.is_example_server ? "${var.tags["Environment"]}-${var.tags["Application"]}-shared-CPU-Utilization-High-${var.ecs_as_cpu_high_threshold_per}" : "${var.tags["Environment"]}-${var.tags["Application"]}-CPU-Utilization-High-${var.ecs_as_cpu_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cw_cpu_metric_alarm_evaluation
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.cw_metric_alarms_period
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_high_threshold_per

  dimensions = {
    ClusterName = var.create_ecs_cluster ? aws_ecs_cluster.ecs[0].name : var.cluster_name
    ServiceName = var.create_preparation_handler ? aws_ecs_service.ecs_prep_handler[0].name : aws_ecs_service.ecs[0].name
  }

  alarm_actions = [
    element(concat(aws_appautoscaling_policy.up.*.arn, tolist([""])), 0),
  ]

}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
  count               = var.create_cw_metric ? 1 : 0
  alarm_name          = var.is_example_server ? "${var.tags["Environment"]}-${var.tags["Application"]}-shared-CPU-Utilization-Low-${var.ecs_as_cpu_low_threshold_per}" : "${var.tags["Environment"]}-${var.tags["Application"]}-CPU-Utilization-Low-${var.ecs_as_cpu_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.cw_cpu_metric_alarm_evaluation
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.cw_metric_alarms_period
  statistic           = "Average"
  threshold           = var.ecs_as_cpu_low_threshold_per

  dimensions = {
    ClusterName = var.create_ecs_cluster ? aws_ecs_cluster.ecs[0].name : var.cluster_name
    ServiceName = var.create_preparation_handler ? aws_ecs_service.ecs_prep_handler[0].name : aws_ecs_service.ecs[0].name
  }

  alarm_actions = [
    element(concat(aws_appautoscaling_policy.down.*.arn, tolist([""])), 0),
  ]


}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_high" {
  count               = var.create_cw_metric ? 1 : 0
  alarm_name          = var.is_example_server ? "${var.tags["Environment"]}-${var.tags["Application"]}-shared-Memory-Utilization-High-${var.ecs_as_memory_high_threshold_per}" : "${var.tags["Environment"]}-${var.tags["Application"]}-Memory-Utilization-High-${var.ecs_as_memory_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cw_memory_metric_alarm_evaluation
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = var.cw_metric_alarms_period
  statistic           = "Average"
  threshold           = var.ecs_as_memory_high_threshold_per

  dimensions = {
    ClusterName = var.create_ecs_cluster ? aws_ecs_cluster.ecs[0].name : var.cluster_name
    ServiceName = var.create_preparation_handler ? aws_ecs_service.ecs_prep_handler[0].name : aws_ecs_service.ecs[0].name
  }

}

