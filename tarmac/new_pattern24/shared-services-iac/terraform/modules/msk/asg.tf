###### Storage Autoscaling

resource "aws_appautoscaling_target" "target" {
  count = var.create && var.enable_storage_autoscaling ? 1 : 0

  max_capacity       = var.scaling_max_capacity
  min_capacity       = 1
  role_arn           = var.scaling_role_arn
  resource_id        = aws_msk_cluster.msk[0].arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "policy" {
  count = var.create && var.enable_storage_autoscaling ? 1 : 0

  name               = "${var.name}-broker-storage-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.msk[0].arn
  scalable_dimension = aws_appautoscaling_target.target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }

    target_value = var.scaling_target_value
  }
}

