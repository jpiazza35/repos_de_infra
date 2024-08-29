resource "aws_security_group" "aurora_vpc_segurity_group" {
  name        = "aurora-sg"
  description = "Default Aurora security group to allow inbound from the ECS task"
  vpc_id      = var.db_cluster_vpc_id
}

resource "aws_security_group_rule" "allow_3306_from_vpn" {
  count                    = var.environment == "dev" ? 1 : 0
  description              = "allow 3306 from vpn"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aurora_vpc_segurity_group.id
  source_security_group_id = var.db_vpn_security_group_id
}

resource "aws_security_group_rule" "allow_3306_from_pvt_subnets" {
  description       = "allow 3306 from pvt subnets"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.aurora_vpc_segurity_group.id
  cidr_blocks       = var.private_subnets
}