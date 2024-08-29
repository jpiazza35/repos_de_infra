### Security Groups
resource "aws_security_group" "bastion" {
  count       = local.default
  name        = "sgrp-${var.app}-${var.env}"
  description = "Allow Bastion EC2 Traffic"
  vpc_id      = var.vpc_id == "" ? data.aws_vpc.vpc[count.index].id : var.vpc_id

  ingress {
    description = "Ingress from VPC to all ports and protocols."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc[count.index].cidr_block
    ]
  }

  dynamic "ingress" {
    for_each = {
      for sgr in var.additional_sg_rules : "ingress-${sgr.from_port}-${sgr.protocol}-to-${sgr.to_port}-${sgr.protocol}" => sgr
      if var.additional_sg_rules != [] && sgr.type == "ingress"
    }
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = "Egress to world on all ports and protocols"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "egress" {
    for_each = {
      for sgr in var.additional_sg_rules : "egress-${sgr.from_port}-${sgr.protocol}-to-${sgr.to_port}-${sgr.protocol}" => sgr
      if var.additional_sg_rules != [] && sgr.type == "egress"
    }
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name           = "sg-${var.app}-${var.env}"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}

resource "aws_security_group_rule" "asg_app_admin_rule" {
  count       = local.default
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  description = "Access to SC network CIDR."
  cidr_blocks = [
    "10.0.0.0/8"
  ]
  security_group_id = aws_security_group.bastion[count.index].id
}
