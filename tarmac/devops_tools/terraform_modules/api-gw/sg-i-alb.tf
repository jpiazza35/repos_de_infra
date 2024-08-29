resource "aws_security_group" "sg_i_alb" {
  count                  = var.create_lb_resources ? 1 : 0
  name                   = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-alb-sgrp"
  description            = "The security group for the ${var.tags["Environment"]} ${var.tags["Product"]} internal Application Load Balancer."
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-alb-sg"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "i_alb_in_vpc_443" {
  count             = var.create_lb_resources ? 1 : 0
  description       = "Ingress to internal ALB from VPC CIDR Block on port 443."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_i_alb[0].id
  cidr_blocks       = [var.vpc_cidr_block]

  depends_on = [aws_security_group.sg_i_alb]
}

resource "aws_security_group_rule" "i_alb_from_jump_host_443" {
  count             = var.create_alb_to_jump_host_sg_rule ? 1 : 0
  description       = "Ingress to internal ALB from Jum Host CIDR Block on port 443."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_i_alb[0].id
  cidr_blocks       = [var.jump_host_cidr_block]

  depends_on = [aws_security_group.sg_i_alb]
}

resource "aws_security_group_rule" "i_alb_to_private_subnets" {
  count             = var.create_lb_resources ? 1 : 0
  description       = "Egress from internal ALB to private subnets on port 8080."
  type              = "egress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_i_alb[0].id
  cidr_blocks       = var.private_subnets_cidr_blocks

  depends_on = [aws_security_group.sg_i_alb]
}

resource "aws_security_group_rule" "i_alb_to_80" {
  count             = var.create_lb_resources ? 1 : 0
  description       = "Egress from internal ALB to VPC CIDR Block on port 80."
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_i_alb[0].id
  cidr_blocks       = [var.vpc_cidr_block]

  depends_on = [aws_security_group.sg_i_alb]
}

resource "aws_security_group_rule" "i_alb_to_443" {
  count             = var.create_lb_resources ? 1 : 0
  description       = "Egress from internal ALB to VPC CIDR Block on port 443."
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_i_alb[0].id
  cidr_blocks       = [var.vpc_cidr_block]

  depends_on = [aws_security_group.sg_i_alb]
}
