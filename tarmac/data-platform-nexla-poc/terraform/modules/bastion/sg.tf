resource "aws_security_group" "bastion_host_sg" {
  name        = "${var.tags["Env"]}-${var.tags["Name"]}-sg"
  description = "${var.tags["Env"]}-${var.tags["Name"]}-sg"
  vpc_id      = var.properties.vpc_id
  lifecycle {
    create_before_destroy = "true"
  }

  dynamic "ingress" {
    for_each = var.properties.allow_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_block
    }
  }

  dynamic "egress" {
    for_each = var.properties.allow_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_block
    }
  }

  tags = {
    Name = "${var.tags["Env"]}-${var.tags["Name"]}-sg"
    Env  = var.tags["Env"]
  }
}
