resource "aws_security_group" "os_lambdas" {
  count       = var.send_cloudtrail_logs ? 1 : 0
  vpc_id      = var.vpc_id
  name        = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-os-lambdas-sgrp"
  description = "The security group for the ES Lambda functions."

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Moniker"]}-${var.tags["Environment"]}-${var.tags["Application"]}-os-lambdas-sgrp"
    },
  )
}

resource "aws_security_group_rule" "egress_os_443" {
  count             = var.send_cloudtrail_logs ? 1 : 0
  description       = "Egress to OpenSearch on 443."
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.os_lambdas[count.index].id
  cidr_blocks       = [var.logging_aws_account_cidr_block]
}