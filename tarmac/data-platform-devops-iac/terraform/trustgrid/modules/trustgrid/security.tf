### Security Groups
resource "aws_security_group" "ec2" {

  name        = format("%s-%s-sg", var.app, var.env)
  description = "Allow ${title(var.app)} Traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block
    ]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-%s-sg", var.app, var.env)
  }
}

resource "aws_security_group_rule" "additional" {
  for_each          = { for rule in local.additional_sg_rules : "${rule.type}.${rule.from_port}" => rule }
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  description       = each.value.description
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.ec2.id
}