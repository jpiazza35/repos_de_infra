resource "aws_security_group" "postgresql" {
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-postgresql-rds-sgrp"
  description = "The security group for the ${var.tags["Environment"]} ${var.tags["Product"]} RDS Postgresql database."
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = "true"
  }

  tags = merge(
    {
      Name = "${var.tags["Environment"]}-${var.tags["Product"]}-postgresql-rds-sg"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "ingress_from_private_subnets" {
  description       = "Ingress from private subnets to RDS."
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.postgresql.id
  cidr_blocks       = var.private_subnets_cidr_blocks
}

resource "aws_security_group_rule" "ingress_from_vpn" {
  count             = var.create_vpn_sg_rules ? 1 : 0
  description       = "Temporary ingress from temp account VPN EC2."
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.postgresql.id
  cidr_blocks       = [var.temp_vpc_cidr_block]
}

resource "aws_security_group_rule" "ingress_from_jump_host" {
  description       = "Ingress from Jump Host to RDS."
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.postgresql.id
  cidr_blocks       = [var.jump_host_cidr]
}

resource "aws_security_group_rule" "ingress_from_app" {
  count             = var.threedssv_app_host_cidr == "" ? 0 : 1
  description       = "Ingress from app Host to RDS."
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.postgresql.id
  cidr_blocks       = [var.threedssv_app_host_cidr]
}
