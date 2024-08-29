resource "aws_security_group" "open_search" {
  count = var.create_opensearch ? 1 : 0

  vpc_id      = var.vpc_id
  name        = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-open-search-sgrp"
  description = "The security group for the ${var.tags["Environment"]} ${var.tags["Product"]} Open Search service."

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-open-search-sgrp"
    },
  )
}

resource "aws_security_group_rule" "ingress_80_os" {
  count = var.create_opensearch ? 1 : 0

  description       = "Ingress to OS on port 80 from example-account VPC CIDR block."
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.example-account_cidr_block]
  security_group_id = element(concat(aws_security_group.open_search.*.id, tolist([""])), 0)
}

resource "aws_security_group_rule" "ingress_443_os" {
  count = var.create_opensearch ? 1 : 0

  description       = "Ingress to OS on port 443 from example-account VPC CIDR block."
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.example-account_cidr_block]
  security_group_id = element(concat(aws_security_group.open_search.*.id, tolist([""])), 0)
}