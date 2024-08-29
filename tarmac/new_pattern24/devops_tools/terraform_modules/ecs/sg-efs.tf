resource "aws_security_group" "efs" {
  count       = var.create_da_cli_efs ? 1 : 0
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-ecs-efs-sgrp"
  description = "The security group for the EFS volume of the ${var.tags["Environment"]} ${var.tags["Application"]} ECS service."
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.tags["Environment"]}-${var.tags["Application"]}-ecs-efs-sg"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "ingress_ECS" {
  count                    = var.create_da_cli_efs ? 1 : 0
  description              = "ECS to EFS"
  type                     = "ingress"
  from_port                = "2049"
  to_port                  = "2049"
  protocol                 = "tcp"
  source_security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
  security_group_id        = aws_security_group.efs[0].id
}

resource "aws_security_group_rule" "egress_efs_vpc" {
  count             = var.create_da_cli_efs ? 1 : 0
  description       = "Egress from EFS to private VPC subnets."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.private_subnets_cidr_blocks
  security_group_id = aws_security_group.efs[0].id
}
