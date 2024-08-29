resource "aws_cloudwatch_log_group" "fargate" {
  name              = "ecs/${var.name}-${var.tags["env"]}"
  retention_in_days = 30
}

resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = "scheduled-ecs-event-rule"
  schedule_expression = "rate(2 hours)"
}

resource "aws_cloudwatch_event_target" "scheduled_task" {
  rule     = aws_cloudwatch_event_rule.scheduled_task.name
  arn      = data.aws_ecs_cluster.current.arn
  role_arn = aws_iam_role.scheduled_task_cloudwatch.arn

  ecs_target {
    task_count = 1

    # --- use this line for initial deployment only---
    # task_definition_arn = aws_ecs_task_definition.ecs-task-def.arn 

    # --- after first deployment use this line in order to fetch the latest task definition revision ---
    task_definition_arn = "arn:aws:ecs:${var.region}:${data.aws_caller_identity.current.account_id}:task-definition/${aws_ecs_task_definition.ecs-task-def.family}:${max(
      aws_ecs_task_definition.ecs-task-def.revision,
      data.aws_ecs_task_definition.ecs-task-def.revision,
    )}"

    launch_type      = "FARGATE"
    platform_version = "1.4.0"

    network_configuration {
      subnets          = data.aws_subnet_ids.private.ids
      assign_public_ip = var.assign_public_ip
      security_groups  = [aws_security_group.ecs-service-sg[0].id]
    }
  }
}

resource "aws_iam_role" "scheduled_task_cloudwatch" {
  name               = "${var.name}-${var.tags["env"]}-st-cw-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "scheduled_task_cloudwatch_policy" {
  name = "${var.name}-${var.tags["env"]}-st-cw-policy"
  role = aws_iam_role.scheduled_task_cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "*"
        }
    ]
}
EOF
}