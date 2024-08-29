#ECS Cluster

resource "aws_ecs_cluster" "ecs" {
  name = "${var.environment}-default-ecs"
}

# ETL ECS Service

resource "aws_ecs_service" "public_ecs" {
  for_each = { for key, val in var.config_services : key => val if val.type == "public" }
  name     = each.value.name
  cluster  = aws_ecs_cluster.ecs.id
  enable_execute_command = var.exec_command
  task_definition = "${aws_ecs_task_definition.ecs[each.key].family}:${max(
    aws_ecs_task_definition.ecs[each.key].revision,
    data.aws_ecs_task_definition.ecs[each.key].revision,
  )}"
  #task_definition                    = aws_ecs_task_definition.ecs.arn
  #task_definition     = aws_ecs_task_definition.ecs[each.key].id
  desired_count       = 1
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  load_balancer {
    target_group_arn = aws_lb_target_group.internal[each.key].arn
    container_name   = each.value.taskDefinitionValues["container_name"]
    container_port   = each.value.taskDefinitionValues["container_port"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.external[each.key].arn
    container_name   = each.value.taskDefinitionValues["container_name"]
    container_port   = each.value.taskDefinitionValues["container_port"]
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_security_group.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
}
resource "aws_ecs_service" "private_ecs" {
  for_each = { for key, val in var.config_services : key => val if val.type == "private" }
  name     = each.value.name
  cluster  = aws_ecs_cluster.ecs.id
  enable_execute_command = var.exec_command
  task_definition = "${aws_ecs_task_definition.ecs[each.key].family}:${max(
    aws_ecs_task_definition.ecs[each.key].revision,
    data.aws_ecs_task_definition.ecs[each.key].revision,
  )}"
  #task_definition     = aws_ecs_task_definition.ecs[each.key].id
  desired_count       = 1
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  load_balancer {
    target_group_arn = aws_lb_target_group.internal[each.key].arn
    container_name   = each.value.taskDefinitionValues["container_name"]
    container_port   = each.value.taskDefinitionValues["container_port"]
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_security_group.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
}

resource "aws_ecs_service" "worker_ecs" {
  for_each = { for key, val in var.config_services : key => val if val.type == "worker" }
  name     = each.value.name
  cluster  = aws_ecs_cluster.ecs.id
  enable_execute_command = var.exec_command
  task_definition = "${aws_ecs_task_definition.ecs[each.key].family}:${max(
    aws_ecs_task_definition.ecs[each.key].revision,
    data.aws_ecs_task_definition.ecs[each.key].revision,
  )}"
  #task_definition     = aws_ecs_task_definition.ecs[each.key].id
  desired_count       = 1
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_security_group.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }
}

resource "aws_ecs_task_definition" "ecs" {
  for_each                 = var.config_services
  family                   = each.value.taskDefinitionValues["container_name"]
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = templatefile(var.container_definitions, each.value.taskDefinitionValues)
}

resource "aws_appautoscaling_target" "ecs_target" {
  for_each           = var.config_services
  max_capacity       = each.value.max_capacity
  min_capacity       = each.value.min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${each.value.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  for_each           = aws_appautoscaling_target.ecs_target
  name               = "policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = each.value.resource_id
  scalable_dimension = each.value.scalable_dimension
  service_namespace  = each.value.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}

resource "aws_appautoscaling_policy" "ecs_policy_mem" {
  for_each           = aws_appautoscaling_target.ecs_target
  name               = "policy-mem"
  policy_type        = "TargetTrackingScaling"
  resource_id        = each.value.resource_id
  scalable_dimension = each.value.scalable_dimension
  service_namespace  = each.value.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
  depends_on = [aws_appautoscaling_target.ecs_target]
}
