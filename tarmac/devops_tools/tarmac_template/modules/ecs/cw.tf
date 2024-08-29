resource "aws_cloudwatch_log_group" "ecs" {
  for_each          = var.config_services
  name              = "/ecs/${var.environment}-${each.value.name}"
  retention_in_days = 7

  tags = {
    Name = "/ecs/${var.environment}-${each.value.name}"
  }
}
