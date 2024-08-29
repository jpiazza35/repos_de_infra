# One ECS cluster per product
resource "aws_ecs_cluster" "ecs" {
  count = var.create_ecs_cluster ? 1 : 0

  name = "${var.tags["Environment"]}-${var.tags["Product"]}"

  tags = var.tags
}

resource "aws_ecs_service" "ecs" {
  count = var.create_ecs_service ? var.ecs_service_count : 0

  name = "my-example-service"

  task_definition = "${aws_ecs_task_definition.ecs[0].family}:${max(
    aws_ecs_task_definition.ecs[0].revision,
    element(concat(data.aws_ecs_task_definition.ecs.*.revision, tolist([""])), 0),
  )}"
  #task_definition                    = aws_ecs_task_definition.ecs.arn
  cluster                            = var.create_ecs_cluster ? aws_ecs_cluster.ecs[0].arn : var.cluster_arn
  desired_count                      = var.desired_count
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  deployment_controller {
    type = var.deployment_controller_type
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.i_ecs[0].arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.ecs.arn
  }

  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  launch_type                       = "FARGATE"
  scheduling_strategy               = "REPLICA"

  # lifecycle {
  #   ignore_changes   = ["desired_count"]
  # }

  tags = var.tags

  depends_on = [aws_ecs_task_definition.ecs, aws_lb_listener_rule.i_alb_public_listener_rule]
}

resource "aws_ecs_task_definition" "ecs" {
  count                    = var.create_ecs_task_definition ? 1 : 0
  family                   = "${var.tags["Environment"]}-${var.tags["Application"]}-task-definition"
  task_role_arn            = aws_iam_role.ecs.arn
  execution_role_arn       = aws_iam_role.ecs.arn
  container_definitions    = var.container_definitions
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = var.requires_compatibilities
  network_mode             = "awsvpc"

  tags = var.tags
}

resource "aws_ecs_task_definition" "ecs_efs" {
  count                    = var.create_da_cli_efs ? 1 : 0
  family                   = "${var.tags["Environment"]}-${var.tags["Application"]}-task-definition"
  task_role_arn            = aws_iam_role.ecs.arn
  execution_role_arn       = aws_iam_role.ecs.arn
  container_definitions    = var.container_definitions
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = var.requires_compatibilities
  network_mode             = "awsvpc"

  volume {
    name = "${var.tags["Environment"]}-${var.tags["Application"]}-efs"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.ecs_efs[0].id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.ecs_efs[0].id
      }
    }
  }

  tags = var.tags

  depends_on = [aws_efs_file_system.ecs_efs]
}
