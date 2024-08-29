resource "aws_security_group" "vpn" {
  name        = "sgrp-${var.tags["Environment"]}-${var.tags["Name"]}"
  description = "Security group for ${var.tags["Environment"]}-${var.tags["Name"]}}"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = "true"
  }

  tags = merge(
    {
      "Name" = "sg-${var.tags["Environment"]}-${var.tags["Name"]}}"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "ssh" {
  description       = "ssh from out"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.vpn.id
  cidr_blocks       = [var.tarmac_mkd_office_static_ip]
}

resource "aws_security_group_rule" "udp" {
  description       = "openvpn port"
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "UDP"
  security_group_id = aws_security_group.vpn.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "world" {
  description       = "to world"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.vpn.id
  cidr_blocks       = ["0.0.0.0/0"]
}
