resource "aws_security_group" "main" {
  name        = "${var.env}-${var.app}-sg"
  description = "Allow incoming traffic from entire vpc and open outgoing to world."
  vpc_id      = var.vpc.id

  ingress {
    description = "Ingress from VPC to all ports and protocols."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.vpc.cidr_block
    ]

  }

  egress {
    description = "Egress to world on all ports and protocols"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
