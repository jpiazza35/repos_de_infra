resource "aws_security_group" "sg-alb-ecs" {
  name                   = "sgrp-alb-ecs-services-${var.tags["act"]}"
  description            = "sg for alb ecs services"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(var.tags,
  tomap({ "Name" = "sg-аlb-ecs-services-${lower(var.tags["act"])}" }))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb-in-443" {
  description       = "alb in world"
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-alb-ecs.id
  cidr_blocks       = ["0.0.0.0/0"]

  depends_on = [aws_security_group.sg-alb-ecs]
}

resource "aws_security_group_rule" "alb-to-8080" {
  description       = "alb to ecs"
  type              = "egress"
  from_port         = "8080"
  to_port           = "8080"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-alb-ecs.id
  cidr_blocks       = [data.aws_vpc.current.cidr_block]

  depends_on = [aws_security_group.sg-alb-ecs]
}