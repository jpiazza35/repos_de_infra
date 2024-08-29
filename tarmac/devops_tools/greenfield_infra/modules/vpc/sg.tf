resource "aws_security_group" "sg-ssm" {
  name                   = "sgrp-vpc-session-manager"
  description            = "sg for session-manager"
  vpc_id                 = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  tags = merge(
    {
      "Name" = "sg-vpc-session-manager"
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "aws-to-vpc" {
  description       = "from aws ssm"
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-ssm.id
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "vpc-to-aws" {
  description       = "to aws ssm"
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-ssm.id
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
}
