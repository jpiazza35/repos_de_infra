resource "aws_cloudwatch_log_group" "fargate" {
  name              = "ecs/${var.name}-${var.tags["env"]}"
  retention_in_days = 30
}