resource "aws_security_group" "sg-i-alb-ecs" {
  name                   = "sgrp-i-alb-ecs-services-${var.tags["act"]}"
  description            = "sg for internal alb ecs services"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(var.tags,
  tomap({ "Name" = "sg-i-аlb-ecs-services-${lower(var.tags["act"])}" }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "i-alb-in-services" {
  description       = "i-alb in from services"
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-i-alb-ecs.id
  cidr_blocks       = [var.cidr_blocks]

  depends_on = [aws_security_group.sg-i-alb-ecs]
}

resource "aws_security_group_rule" "i-alb-in-services-80" {
  description       = "i-alb in from services"
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-i-alb-ecs.id
  cidr_blocks       = [var.cidr_blocks]

  depends_on = [aws_security_group.sg-i-alb-ecs]
}

resource "aws_security_group_rule" "i-alb-to-8080" {
  description       = "i-alb to ecs"
  type              = "egress"
  from_port         = "8080"
  to_port           = "8080"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-i-alb-ecs.id
  cidr_blocks       = [var.cidr_blocks]

  depends_on = [aws_security_group.sg-i-alb-ecs]
}
