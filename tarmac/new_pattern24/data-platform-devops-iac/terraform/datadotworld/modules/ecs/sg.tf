resource "aws_security_group" "ecs_security_group" {
  name   = "${var.properties.environment}-${var.properties.product}-${var.properties.name}-sg"
  vpc_id = var.properties.vpc_id

  dynamic "ingress" {
    for_each = var.properties.ecs.security_group_rules.ingress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
      self        = ingress.value["self"]
    }
  }

  dynamic "egress" {
    for_each = var.properties.ecs.security_group_rules.egress
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
      self        = egress.value["self"]
    }
  }
}
