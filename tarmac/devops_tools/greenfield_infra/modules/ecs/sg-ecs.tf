resource "aws_security_group" "ecs-service-sg" {
  name        = "sgrp-ecs-service-${var.name}-${var.tags["env"]}"
  description = "sg for ecs ${var.name}"
  vpc_id      = var.vpc_id
  tags        = merge(tomap({ "Name" = "${var.name}-ecs-fargate" }), var.tags)

}

resource "aws_security_group_rule" "ingress-container-port" {
  description              = "alb to container port"
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs-service-sg.id
  source_security_group_id = aws_security_group.sg-alb-ecs.id
}

resource "aws_security_group_rule" "i-ingress-container-port" {
  description              = "i-alb to container port"
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs-service-sg.id
  source_security_group_id = aws_security_group.sg-i-alb-ecs.id
}

resource "aws_security_group_rule" "private-sub-container-port" {
  description       = "private subnets to container port"
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_blocks]
  security_group_id = aws_security_group.ecs-service-sg.id
}

resource "aws_security_group_rule" "egress-80" {
  description       = "ecs service out to world 80"
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs-service-sg.id
}

resource "aws_security_group_rule" "egress-443" {
  description       = "ecs service out to world 443"
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs-service-sg.id
}

resource "aws_security_group_rule" "egress-5432" {
  description              = "ecs service out to postgres rds 5432"
  type                     = "egress"
  from_port                = "5432"
  to_port                  = "5432"
  protocol                 = "tcp"
  source_security_group_id = var.rds_security_group_id
  security_group_id        = aws_security_group.ecs-service-sg.id
}

resource "aws_security_group_rule" "egress-alb-443" {
  description              = "ecs service out to alb 443"
  type                     = "egress"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs-service-sg.id
  source_security_group_id = aws_security_group.sg-alb-ecs.id
}

resource "aws_security_group_rule" "egress-i-alb-443" {
  description              = "ecs service out to i-alb 443"
  type                     = "egress"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs-service-sg.id
  source_security_group_id = aws_security_group.sg-i-alb-ecs.id
}