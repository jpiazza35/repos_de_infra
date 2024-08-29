resource "aws_security_group" "workspaces" {
  name        = var.app
  description = "Allow inbound traffic to AWS Workspaces"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      var.ingress_cidr
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    var.tags,
    {
      Name = var.app
    }
  )
}
