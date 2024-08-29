resource "aws_security_group" "redis_lambdas" {
  count       = var.create_ci_cd_lambdas ? 1 : 0
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-redis-lambdas-sgrp"
  description = "The security group for the Redis Lambda functions."
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.tags["Environment"]}-${var.tags["Product"]}-redis-lambdas-sg"
    },
    var.tags,
  )
}

resource "aws_security_group_rule" "egress_redis_6379" {
  count                    = var.create_ci_cd_lambdas ? 1 : 0
  description              = "Egress to Redis on 6379."
  type                     = "egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis_lambdas[count.index].id
  source_security_group_id = aws_security_group.sg_redis.id
}
