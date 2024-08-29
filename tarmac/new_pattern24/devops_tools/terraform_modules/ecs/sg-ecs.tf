resource "aws_security_group" "ecs" {
  name        = "${var.tags["Environment"]}-${var.tags["Application"]}-ecs-sgrp"
  description = "The security group for the ${var.tags["Environment"]} ${var.tags["Application"]} ECS service."
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.tags["Environment"]}-${var.tags["Application"]}-ecs-sg"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "ingress_from_private_subnets" {
  description       = "Ingress to ECS service from private subnets."
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
  cidr_blocks       = var.private_subnets_cidr_blocks
}

resource "aws_security_group_rule" "ingress_vpn_container_port" {
  count             = var.create_vpn_sg_rules ? 1 : 0
  description       = "Ingress to ECS service from temporary VPN EC2 on container port."
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
  cidr_blocks       = [var.temp_vpc_cidr_block]
}

resource "aws_security_group_rule" "ingress_EFS" {
  count                    = var.create_da_cli_efs ? 1 : 0
  description              = "EFS to ECS"
  type                     = "ingress"
  from_port                = "2049"
  to_port                  = "2049"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.efs[0].id
  security_group_id        = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
}

resource "aws_security_group_rule" "ingress_jump_host_container_port" {
  count             = var.create_jump_host_sg_rule ? 1 : 0
  description       = "Ingress to ECS service from the PP Jump host on container port."
  type              = "ingress"
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
  cidr_blocks       = [var.jump_host_cidr_block]
}

resource "aws_security_group_rule" "egress_to_private_subnets" {
  description       = "Egress from ECS service to private subnets."
  type              = "egress"
  from_port         = var.egress_port_to_subnets
  to_port           = var.egress_port_to_subnets
  protocol          = "tcp"
  security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
  cidr_blocks       = var.private_subnets_cidr_blocks
}

resource "aws_security_group_rule" "egress_to_postgresql" {
  count                    = var.create_postgresql_sg_rule ? 1 : 0
  description              = "Egress from ECS service to RDS postgresql."
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = var.db_postgresql_sg_id
}

resource "aws_security_group_rule" "egress_to_redis" {
  count                    = var.create_redis_sg_rule ? 1 : 0
  description              = "Egress from ECS service to Elasticache Redis cluster."
  type                     = "egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = var.elasticache_redis_sg_id
}

resource "aws_security_group_rule" "egress_to_opensearch" {
  count                    = var.create_opensearch_sg_rule ? 1 : 0
  description              = "Egress from ECS service to Opensearch."
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs.id
  source_security_group_id = var.elasticsearch_sg_id
}

resource "aws_security_group_rule" "egress_s3_vpc_endpoint" {
  count             = var.create_sg_rules ? 1 : 0
  description       = "Egress from ECS service to private s3 VPC endpoint."
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
  prefix_list_ids   = [var.s3_vpc_endpoint_prefix_id]
}


resource "aws_security_group_rule" "egress_vpc_endpoints_sg_443" {
  count                    = var.create_sg_rules ? 1 : 0
  description              = "Egress from ECS service to private VPC endpoints security group on port 443."
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.vpc_endpoints_sg_id
  security_group_id        = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
}

resource "aws_security_group_rule" "egress_nca_acquiring_443" {
  count             = var.create_acquiring_iam_sg_rule ? 1 : 0
  description       = "Egress from ECS service to the NCA acquiring IAM server on port 443."
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.nca_acquiring_iam_ip_address]
  security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
}

resource "aws_security_group_rule" "egress_vpc_endpoints_sg_80" {
  count                    = var.create_sg_rules ? 1 : 0
  description              = "Egress from ECS service to private VPC endpoints security group on port 80."
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = var.vpc_endpoints_sg_id
  security_group_id        = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "egress_world_443" {
  count             = var.create_egress_internet ? 1 : 0
  description       = "Egress from ECS service to the world on port 443."
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
}

resource "aws_security_group_rule" "egress_to_riskshield_443" {
  count             = var.create_egress_riskshield ? 1 : 0
  description       = "Egress from ECS service to Riskshield on port 443."
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.riskshield_ip]
  security_group_id = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
}

resource "aws_security_group_rule" "egress_EFS" {
  count                    = var.create_da_cli_efs ? 1 : 0
  description              = "ECS to EFS"
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.efs[0].id
  security_group_id        = element(concat(aws_security_group.ecs.*.id, tolist([""])), 0)
}
