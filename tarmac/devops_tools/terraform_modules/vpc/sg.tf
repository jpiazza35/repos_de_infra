# remove rules from default security group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.example-account_vpc.id
}

resource "aws_security_group" "example-account_vpc" {
  name                   = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-vpc-endpoints-sgrp"
  description            = "SG for VPC endpoints"
  vpc_id                 = aws_vpc.example-account_vpc.id
  revoke_rules_on_delete = true

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Product"]}-vpc-endpoints-sg"
    },
  )

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_subnet.example-account_private]
}

resource "aws_security_group_rule" "example-account_to_aws_443" {
  description       = "Ingress from example-account on-prem IP block to AWS VPC endpoints SG on 443."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.example-account_vpc.id
  cidr_blocks       = [var.example-account_on_prem1, var.example-account_on_prem2]

  depends_on = [aws_security_group.example-account_vpc]
}

resource "aws_security_group_rule" "aws_to_vpc_443" {
  description       = "Ingress from VPC IP block to VPC endpoints SG on 443."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.example-account_vpc.id
  cidr_blocks       = [aws_vpc.example-account_vpc.cidr_block]

  depends_on = [aws_security_group.example-account_vpc]
}