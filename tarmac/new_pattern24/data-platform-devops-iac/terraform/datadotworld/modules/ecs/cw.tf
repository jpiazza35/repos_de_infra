resource "aws_cloudwatch_log_group" "ecs" {
  for_each          = var.properties.ecs.services
  name              = "/ecs/${var.properties.environment}-${each.value.name}"
  retention_in_days = 7

  tags = {
    Name           = "/ecs/${var.properties.environment}-${var.properties.name}-${each.value.name}"
    SourcecodeRepo = "https://github.com/clinician-nexus/data-platform-iac"
  }
}
