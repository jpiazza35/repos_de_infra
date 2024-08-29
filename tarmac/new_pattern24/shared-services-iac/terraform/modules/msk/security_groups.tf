resource "aws_security_group" "sg" {
  name        = "${var.app}-${var.env}-sg"
  description = "Security group for MSK cluster"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Ingress from VPC to all ports and protocols."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block
    ]
  }

  dynamic "ingress" {
    for_each = {
      for sgr in var.additional_sg_rules : "ingress-${sgr.from_port}-to-${sgr.to_port}" => sgr
      if var.additional_sg_rules != [] && sgr.type == "ingress"
    }
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = try(ingress.value.cidr_blocks, [data.aws_vpc.vpc.cidr_block])
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
      for sgr in var.additional_sg_rules : "egress-${sgr.from_port}-to-${sgr.to_port}" => sgr
      if var.additional_sg_rules != [] && sgr.type == "egress"
    }
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = try(egress.value.cidr_blocks, [data.aws_vpc.vpc.cidr_block])
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.app}-${var.env}-sg"
    }
  )
}

resource "aws_security_group_rule" "asg_app_admin_rule" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  description = "Access to SC network CIDR."
  cidr_blocks = [
    "10.0.0.0/8"
  ]
  security_group_id = aws_security_group.sg.id
}
