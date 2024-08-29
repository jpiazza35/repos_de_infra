resource "aws_ecs_cluster" "cluster" {
  count = local.default
  name  = format("%s-tools-ecs", lower(var.env))

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.ss_tools[count.index].arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  for_each = terraform.workspace == "sharedservices" ? {
  for cps in var.capacity_provider_strategy : cps.capacity_provider => cps } : {}

  cluster_name = aws_ecs_cluster.cluster[0].name

  capacity_providers = [
    each.value.capacity_provider
  ]

  default_capacity_provider_strategy {
    capacity_provider = each.value.capacity_provider
    weight            = each.value.weight
  }
}

resource "aws_service_discovery_http_namespace" "ss_tools" {
  count       = local.default
  name        = format("%s-tools-ecs", lower(var.env))
  description = "SS Tools Namespace"
}
