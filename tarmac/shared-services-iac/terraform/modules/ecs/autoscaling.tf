resource "aws_appautoscaling_target" "ecs_target" {
  for_each = var.autoscaling["enabled"] ? {
    for idx, t in [var.autoscaling["target"]] : idx => t
  } : {}
  max_capacity = each.value.max_capacity
  min_capacity = each.value.min_capacity

  resource_id = coalesce(each.value.resource_id, "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ecs[0].name}")

  scalable_dimension = try(each.value.scalable_dimension, "ecs:service:DesiredCount")

  service_namespace = try(each.value.service_namespace, "ecs")

  tags = merge(
    {
      Name = format("%s-%s-ecs-autoscaling-target", lower(var.cluster["env"]), lower(var.cluster["app"]))
    },
    var.tags,
    {
      Environment    = var.cluster["env"]
      App            = var.cluster["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.cluster["app"]} Related Configuration"
      Team           = var.cluster["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )

}

resource "aws_appautoscaling_policy" "ecs_policy" {
  for_each = var.autoscaling["enabled"] ? {
    for p in var.autoscaling["policy"]["target_tracking_scaling_policy_configuration"] : p.name => p
  } : {}
  name               = format("%s-autoscaling", each.value.name)
  policy_type        = var.autoscaling["policy"]["policy_type"]
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = try(each.value.scalable_dimension, aws_appautoscaling_target.ecs_target[0].scalable_dimension)
  service_namespace  = try(each.value.service_namespace, aws_appautoscaling_target.ecs_target[0].service_namespace)

  dynamic "target_tracking_scaling_policy_configuration" {
    for_each = [each.value]
    iterator = target_tracking
    content {
      target_value       = target_tracking.value.target_value
      scale_in_cooldown  = target_tracking.value.scale_in_cooldown
      scale_out_cooldown = target_tracking.value.scale_out_cooldown

      dynamic "predefined_metric_specification" {
        for_each = [target_tracking.value.predefined_metric_specification]

        iterator = pmd
        content {
          predefined_metric_type = pmd.value.predefined_metric_type

          resource_label = pmd.value.resource_label
        }
      }
    }
  }
}
