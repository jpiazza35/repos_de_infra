data "aws_ecs_task_definition" "ecs" {
  for_each        = var.config_services
  task_definition = aws_ecs_task_definition.ecs[each.key].family
}

##
#task_definition  = "${aws_ecs_task_definition.etl_task_definition_def.family}:${data.aws_ecs_task_definition.etl_task_definition_def.revision}"

#task_definition  = "${aws_ecs_task_definition.etl_worker_task_definition_def.family}:${data.aws_ecs_task_definition.etl_worker_task_definition_def.revision}"

#task_definition  = "${aws_ecs_task_definition.backend_task_definition_def.family}:${data.aws_ecs_task_definition.backend_task_definition_def.revision}"

#task_definition  = "${aws_ecs_task_definition.backend_worker_task_definition_def.family}:${data.aws_ecs_task_definition.backend_worker_task_definition_def.revision}"
