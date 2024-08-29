resource "aws_ecs_service" "phpipam" {
  count = local.default
  name  = "phpipam" #format("%s-ecs-service", lower(var.env))

  cluster         = aws_ecs_cluster.cluster[count.index].id
  task_definition = "${aws_ecs_task_definition.task[count.index].family}:${max(aws_ecs_task_definition.task[count.index].revision, data.aws_ecs_task_definition.task[count.index].revision)}"

  desired_count  = var.desired_count
  propagate_tags = var.propagate_tags

  platform_version = var.platform_version
  launch_type      = length(var.capacity_provider_strategy) == 0 ? "FARGATE" : null

  force_new_deployment    = var.force_new_deployment
  wait_for_steady_state   = var.wait_for_steady_state
  enable_execute_command  = var.enable_execute_command
  enable_ecs_managed_tags = var.enable_ecs_managed_tags

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.load_balanced ? var.health_check_grace_period_seconds : null

  network_configuration {
    subnets = concat(
      var.private_subnet_ids,
    )

    security_groups = [
      aws_security_group.ecs_service[count.index].id
    ]
    assign_public_ip = var.task_container_assign_public_ip
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  load_balancer {
    container_name   = "phpipam-web"
    container_port   = 80
    target_group_arn = aws_lb_target_group.task["ss-alb-tg"].arn
  }

  deployment_circuit_breaker {
    enable   = var.enable_deployment_circuit_breaker
    rollback = var.enable_deployment_circuit_breaker_rollback
  }

  deployment_controller {
    type = var.deployment_controller_type
  }

  dynamic "service_registries" {
    for_each = var.service_registry_arn == "" ? [] : [1]
    content {
      registry_arn   = var.service_registry_arn
      container_name = "phpipam-web"
    }
  }

  tags = merge(
    var.tags,
    {
      Name           = "phpipam"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )
}

### Sonatype Artifactory


resource "aws_ecs_service" "sonatype_service" {
  count           = local.default
  name            = "sonatype_nexus"
  cluster         = aws_ecs_cluster.cluster[count.index].id
  task_definition = "${aws_ecs_task_definition.sonatype_td[count.index].family}:${max(aws_ecs_task_definition.sonatype_td[count.index].revision, data.aws_ecs_task_definition.sonatype_td[count.index].revision)}"

  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_lb_target_group.sonatype_task_tg.arn
    container_name   = "sonatype-nexus"
    container_port   = 8081
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  desired_count    = 1
  propagate_tags   = var.propagate_tags
  platform_version = var.platform_version
  launch_type      = length(var.capacity_provider_strategy) == 0 ? "FARGATE" : null

  network_configuration {
    subnets = concat(
      var.private_subnet_ids,
    )

    security_groups = [
      aws_security_group.sonatype_ecs_service[0].id
    ]
    assign_public_ip = var.sonatype_task_container_assign_public_ip
  }

  tags = merge(
    var.tags,
    {
      Name           = "sonatype_artifactory"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )

}


### INCIDENT BOT
resource "aws_ecs_service" "incident_bot_service" {
  count           = local.default
  name            = "incident_bot"
  cluster         = aws_ecs_cluster.cluster[count.index].id
  task_definition = "${aws_ecs_task_definition.incident_bot[count.index].family}:${max(aws_ecs_task_definition.incident_bot[count.index].revision, data.aws_ecs_task_definition.incident_bot[count.index].revision)}"

  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_lb_target_group.incident_bot_task_tg[count.index].arn
    container_name   = "incident-bot"
    container_port   = 3000
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 75

  desired_count    = 1
  propagate_tags   = var.propagate_tags
  platform_version = var.platform_version
  launch_type      = length(var.capacity_provider_strategy) == 0 ? "FARGATE" : null

  network_configuration {
    subnets = concat(
      var.private_subnet_ids,
    )

    security_groups = [
      aws_security_group.ecs_service[count.index].id
    ]
    assign_public_ip = var.incident_bot_task_container_assign_public_ip
  }

  tags = merge(
    var.tags,
    {
      Name           = "incident_bot"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )

}
