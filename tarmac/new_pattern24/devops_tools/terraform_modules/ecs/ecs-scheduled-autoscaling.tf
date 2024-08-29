resource "aws_appautoscaling_target" "scheduled" {
  count = var.create_scheduled_autoscaling ? 1 : 0

  min_capacity       = var.asg_min_capacity
  max_capacity       = var.asg_max_capacity
  resource_id        = var.create_preparation_handler ? "service/${var.tags["Environment"]}-${var.tags["Product"]}/${element(concat(aws_ecs_service.ecs_prep_handler.*.name, tolist([""])), 0)}" : "service/${var.tags["Environment"]}-${var.tags["Product"]}/${element(concat(aws_ecs_service.ecs.*.name, tolist([""])), 0)}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_scheduled_action" "up" {
  count = var.create_scheduled_autoscaling ? 1 : 0

  name               = "${var.tags["Environment"]}-${var.tags["Application"]}-app-autoscale-scheduled-up"
  service_namespace  = aws_appautoscaling_target.scheduled[0].service_namespace
  resource_id        = aws_appautoscaling_target.scheduled[0].resource_id
  scalable_dimension = aws_appautoscaling_target.scheduled[0].scalable_dimension
  schedule           = "cron(00 06 ? * MON-FRI *)"

  scalable_target_action {
    min_capacity = aws_appautoscaling_target.scheduled[0].min_capacity
    max_capacity = aws_appautoscaling_target.scheduled[0].max_capacity
  }
}

resource "aws_appautoscaling_scheduled_action" "down" {
  count = var.create_scheduled_autoscaling ? 1 : 0

  name               = var.is_example_server ? "${var.tags["Environment"]}-${var.tags["Application"]}-shared-app-autoscale-scheduled-down" : "${var.tags["Environment"]}-${var.tags["Application"]}-app-autoscale-scheduled-down"
  service_namespace  = aws_appautoscaling_target.scheduled[0].service_namespace
  resource_id        = aws_appautoscaling_target.scheduled[0].resource_id
  scalable_dimension = aws_appautoscaling_target.scheduled[0].scalable_dimension
  schedule           = "cron(30 18 ? * MON-FRI *)"

  scalable_target_action {
    min_capacity = 0
    max_capacity = 0
  }

  depends_on = [aws_appautoscaling_scheduled_action.up]
}