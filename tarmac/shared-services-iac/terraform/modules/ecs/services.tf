resource "aws_ecs_service" "ecs" {
  for_each = {
    for idx, s in var.ecs_service : idx => s
  }
  name = format("%s-%s-ecs-service", lower(var.cluster["env"]), lower(var.cluster["app"]))

  cluster = aws_ecs_cluster.cluster.id

  task_definition = each.value.task_definition != "" ? try(
  "${aws_ecs_task_definition.task[each.key].family}:${max(aws_ecs_task_definition.task[each.key].revision, data.aws_ecs_task_definition.task[each.key].revision)}") : each.value.task_definition

  desired_count  = each.value.desired_count
  propagate_tags = each.value.propagate_tags

  platform_version = each.value.platform_version
  launch_type      = try(each.value.launch_type, "FARGATE")

  force_new_deployment    = each.value.force_new_deployment
  wait_for_steady_state   = each.value.wait_for_steady_state
  enable_execute_command  = each.value.enable_execute_command
  enable_ecs_managed_tags = each.value.enable_ecs_managed_tags

  deployment_minimum_healthy_percent = each.value.deployment_minimum_healthy_percent
  deployment_maximum_percent         = each.value.deployment_maximum_percent
  health_check_grace_period_seconds  = each.value.load_balancer != null ? try(each.value.health_check_grace_period_seconds, null) : null

  network_configuration {
    subnets = try(each.value.network_configuration.value.subnets, data.aws_subnets.private.ids)

    security_groups = try(each.value.network_configuration.value.security_groups, [aws_security_group.ecs_service.id])

    assign_public_ip = try(each.value.network_configuration.value.assign_public_ip, false)
  }

  dynamic "capacity_provider_strategy" {
    for_each = each.value.capacity_provider_strategy != null ? [each.value.capacity_provider_strategy] : []
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  dynamic "load_balancer" {
    for_each = each.value.load_balancer != null ? [each.value.load_balancer] : []

    content {
      container_name = try(load_balancer.value.container_name, "")

      container_port = try(load_balancer.value.container_port, null)

      target_group_arn = try(load_balancer.value.target_group_arn, null)

      elb_name = try(load_balancer.value.elb_name, null)
    }
  }

  dynamic "deployment_circuit_breaker" {
    for_each = each.value.deployment_circuit_breaker.enable ? [
      each.value.deployment_circuit_breaker
    ] : []

    content {
      enable   = deployment_circuit_breaker.value.enable
      rollback = deployment_circuit_breaker.value.rollback
    }

  }

  deployment_controller {
    type = try(each.value.deployment_controller_type.type, "ECS")
  }

  dynamic "service_registries" {
    for_each = each.value.service_registries != null ? [each.value.service_registries] : []
    content {
      registry_arn   = service_registries.value.registry_arn
      container_name = service_registries.value.container_name
      container_port = service_registries.value.container_port
    }
  }

  dynamic "service_connect_configuration" {
    for_each = each.value.service_connect_configuration.enabled ? [each.value.service_connect_configuration] : []
    iterator = connect

    content {
      enabled = try(connect.value.enabled, false)

      dynamic "log_configuration" {
        for_each = [connect.value.log_configuration]
        iterator = log

        content {
          log_driver = try(log.value.log_driver, null)
          options    = try(log.value.options, {})
          dynamic "secret_option" {
            for_each = [log.value.secret_option]
            content {
              name = try(secret_option.value.name, null)

              value_from = try(secret_option.value.value_from, null)
            }
          }
        }
      }
      namespace = try(connect.value.namespace, null)
      dynamic "service" {
        for_each = [connect.value.service]
        content {
          client_alias {
            dns_name = try(service.value.client_alias.value.dns_name, null)
            port     = try(service.value.client_alias.value.port, null)
          }
          discovery_name        = try(service.value.discovery_name, null)
          ingress_port_override = try(service.value.ingress_port_override, null)
          port_name             = try(service.value.port_name, null)
        }
      }
    }
  }

  tags = merge(
    {
      Name = format("%s-%s-ecs-service", lower(var.cluster["env"]), lower(var.cluster["app"]))
    },
    var.tags,
    {
      Environment    = var.cluster["env"]
      App            = var.cluster["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.cluster["app"]} Related Configuration"
      Team           = var.cluster["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )

  lifecycle {
    ignore_changes = []
  }

}
