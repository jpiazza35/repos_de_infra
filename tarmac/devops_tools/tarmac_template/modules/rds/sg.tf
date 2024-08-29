resource "aws_security_group" "rds_vpc_segurity_group" {
  name        = "rds-sg"
  description = "Default RDS security group to allow inbound from the ECS task"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["10.0.0.0/8"]
  }
}