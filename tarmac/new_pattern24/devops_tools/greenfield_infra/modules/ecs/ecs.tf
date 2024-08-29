resource "aws_ecs_service" "ecs-service" {
  name = "${var.name}-${var.tags["env"]}"
  # task_definition                       = aws_ecs_task_definition.ecs-task-def.family}:${max(aws_ecs_task_definition.ecs-task-def.revision, data.aws_ecs_task_definition.ecs-task-def.revision)}
  task_definition                    = aws_ecs_task_definition.ecs-task-def.arn
  cluster                            = aws_ecs_cluster.ecs-fargate.arn
  desired_count                      = var.desired_count
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  deployment_controller {
    type = var.deployment_controller_type
  }

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.ecs-service-sg.id]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-target-group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.i-ecs-target-group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [aws_lb_target_group.ecs-target-group, aws_lb_target_group.i-ecs-target-group, aws_ecs_task_definition.ecs-task-def]
}

resource "aws_ecs_task_definition" "ecs-task-def" {
  family                   = "${var.name}-app"
  task_role_arn            = aws_iam_role.ecs-default.arn
  execution_role_arn       = aws_iam_role.ecs-default.arn
  container_definitions    = var.container_definitions
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = var.requires_compatibilities
  network_mode             = "awsvpc"
}

resource "aws_ecs_cluster" "ecs-fargate" {
  name = "${var.tags["env"]}-fargate"
}