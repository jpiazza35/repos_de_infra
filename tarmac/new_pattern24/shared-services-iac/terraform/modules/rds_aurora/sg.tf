resource "aws_security_group" "aurora_segurity_group" {
  name        = "${var.tags["env"]}-${var.tags["product"]}-${var.tags["service"]}-sg"
  description = "Default Aurora security group to allow traffic"
  vpc_id      = data.aws_vpc.main.id

  tags = merge(var.tags, tomap(
    {
      Name = "${var.tags["env"]}-${var.tags["product"]}-${var.tags["service"]}-sg"
    }
  ))
}

resource "aws_security_group_rule" "allow_from_entire_network" {
  description       = "allow 5432 from pvt network"
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.aurora_segurity_group.id
  cidr_blocks       = [var.network_cidr]
}
