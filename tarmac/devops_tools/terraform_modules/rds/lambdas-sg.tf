resource "aws_security_group" "rds_lambdas" {
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-lambdas-sgrp"
  description = "The security group for the RDS Lambda functions."
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.tags["Environment"]}-${var.tags["Product"]}-rds-lambdas-sg"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "egress_rds_5432" {
  description              = "Egress to RDS Postgres on 5432."
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_lambdas.id
  source_security_group_id = aws_security_group.postgresql.id
}

resource "aws_security_group_rule" "egress_s3_vpce" {
  description       = "Egress to S3 VPC Endpoint."
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.rds_lambdas.id
  prefix_list_ids   = [var.s3_vpc_endpoint_prefix_id]
}