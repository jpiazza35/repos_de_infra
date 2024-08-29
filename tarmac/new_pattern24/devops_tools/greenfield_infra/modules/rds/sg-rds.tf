resource "aws_security_group" "sg-rds" {
  name        = "sec-rds-${var.tags["env"]}-${var.tags["vpc"]}-${var.tags["service"]}"
  description = "sec-rds-${var.tags["env"]}-${var.tags["vpc"]}-${var.tags["service"]}"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = "true"
  }
  tags = merge(
    tomap({ "Name" = "sg-rds-${var.tags["env"]}-${var.tags["vpc"]}-${var.tags["service"]}" }),
    var.tags
  )
}

resource "aws_security_group_rule" "ec2-in-psql" {
  description              = "psql from ecs-service-sg"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg-rds.id
  source_security_group_id = var.ecs_security_group_id
}