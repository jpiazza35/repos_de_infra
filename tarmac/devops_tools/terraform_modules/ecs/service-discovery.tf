resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name        = var.is_example_server ? "${var.tags["Application"]}-shared" : var.tags["Application"]
  description = "${var.tags["Application"]} ECS Private Service Discovery namespace"
  vpc         = var.vpc_id

  tags = var.tags
}

resource "aws_service_discovery_service" "ecs" {
  name = var.tags["Environment"]

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

