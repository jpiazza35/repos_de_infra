resource "aws_security_group" "sg_redis" {
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-sg-redis-sgrp"
  description = "The security group for the ${var.tags["Environment"]} ${var.tags["Product"]} Redis service."
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.tags["Environment"]}-${var.tags["Product"]}-redis-sg"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "ingress_from_private_subnets" {
  description       = "Ingress from private subnets to Redis."
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = var.private_subnets_cidr_blocks
  security_group_id = aws_security_group.sg_redis.id
}

resource "aws_security_group_rule" "ingress_6379_jump_host" {
  description       = "Ingress to Redis from Jump Host CIDR block."
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = [var.jump_host_cidr]
  security_group_id = aws_security_group.sg_redis.id
}

resource "aws_security_group_rule" "ingress_6379_vpn" {
  count             = var.create_vpn_sg_rule ? 1 : 0
  description       = "Ingress to Redis from temp VPC CIDR block (for VPN)."
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = [var.temp_vpc_cidr_block]
  security_group_id = aws_security_group.sg_redis.id
}