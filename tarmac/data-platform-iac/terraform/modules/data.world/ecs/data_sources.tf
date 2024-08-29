data "aws_caller_identity" "current" {
}

data "aws_ecs_task_definition" "ecs" {
  for_each        = var.properties.ecs.services
  task_definition = aws_ecs_task_definition.ecs[each.key].family
}
