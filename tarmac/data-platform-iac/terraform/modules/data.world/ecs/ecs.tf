#ECS Cluster

resource "aws_ecs_cluster" "ecs" {
  name = "${var.properties.environment}-${var.properties.product}-${var.properties.name}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = var.properties.ecs.containerinsights_enable
  }
}

# ECS Service

resource "aws_ecs_service" "ecs" {
  for_each               = var.properties.ecs.services
  name                   = "${var.properties.environment}-${var.properties.product}-${each.value.name}-ecs-service"
  cluster                = aws_ecs_cluster.ecs.id
  enable_execute_command = each.value.enable_execute_command
  # tags                   = merge(var.tags, each.value.tags)
  task_definition = "${aws_ecs_task_definition.ecs[each.key].family}:${max(
    aws_ecs_task_definition.ecs[each.key].revision,
    data.aws_ecs_task_definition.ecs[each.key].revision,
  )}"
  #task_definition                    = aws_ecs_task_definition.ecs.arn
  #task_definition     = aws_ecs_task_definition.ecs[each.key].id
  desired_count       = each.value.desired_count
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_security_group.id]
    subnets          = var.properties.private_subnets #TODO add to properties
    assign_public_ip = false
  }
}

# ECS Task Definition

resource "aws_ecs_task_definition" "ecs" {
  for_each                 = var.properties.ecs.services
  family                   = each.value.taskDefinitionValues["container_name"]
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = templatefile(var.properties.container_definitions, merge(each.value.taskDefinitionValues, { image = "${aws_ecr_repository.ecr.repository_url}:${each.value.taskDefinitionValues.image_tag}" }))
}
