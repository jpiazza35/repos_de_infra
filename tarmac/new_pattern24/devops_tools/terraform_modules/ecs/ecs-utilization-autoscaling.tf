resource "aws_appautoscaling_target" "utilization" {
  count              = var.create_utilization_autoscaling ? 1 : 0
  max_capacity       = var.asg_max_capacity
  min_capacity       = var.asg_min_capacity
  resource_id        = var.tags["Product"] == "admin" ? "service/${aws_ecs_cluster.ecs[0].name}/${aws_ecs_service.ecs[0].name}" : "service/${var.tags["Environment"]}-${var.tags["Product"]}/${aws_ecs_service.ecs[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    aws_appautoscaling_target.scheduled
  ]
}

resource "aws_appautoscaling_policy" "up" {
  count              = var.create_utilization_autoscaling ? 1 : 0
  name               = "scale-up"
  service_namespace  = element(concat(aws_appautoscaling_target.utilization.*.service_namespace, tolist([""])), 0)
  resource_id        = element(concat(aws_appautoscaling_target.utilization.*.resource_id, tolist([""])), 0)
  scalable_dimension = element(concat(aws_appautoscaling_target.utilization.*.scalable_dimension, tolist([""])), 0)

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "down" {
  count              = var.create_utilization_autoscaling ? 1 : 0
  name               = "scale-down"
  service_namespace  = element(concat(aws_appautoscaling_target.utilization.*.service_namespace, tolist([""])), 0)
  resource_id        = element(concat(aws_appautoscaling_target.utilization.*.resource_id, tolist([""])), 0)
  scalable_dimension = element(concat(aws_appautoscaling_target.utilization.*.scalable_dimension, tolist([""])), 0)

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 180
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}