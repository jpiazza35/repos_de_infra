data "aws_ecs_task_definition" "ecs" {
  for_each        = var.config_services
  task_definition = aws_ecs_task_definition.ecs[each.key].family
}

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    sid = "1"

    actions = [
      "ssm:GetParameters",
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${var.aws_acc_id}:parameter/${var.environment}/internaltool/*",
    ]
  }
  statement {
    sid = "2"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"

    ]

    resources = [
      "*",
    ]
  }
}
##
#task_definition  = "${aws_ecs_task_definition.etl_task_definition_def.family}:${data.aws_ecs_task_definition.etl_task_definition_def.revision}"

#task_definition  = "${aws_ecs_task_definition.etl_worker_task_definition_def.family}:${data.aws_ecs_task_definition.etl_worker_task_definition_def.revision}"

#task_definition  = "${aws_ecs_task_definition.backend_task_definition_def.family}:${data.aws_ecs_task_definition.backend_task_definition_def.revision}"

#task_definition  = "${aws_ecs_task_definition.backend_worker_task_definition_def.family}:${data.aws_ecs_task_definition.backend_worker_task_definition_def.revision}"
