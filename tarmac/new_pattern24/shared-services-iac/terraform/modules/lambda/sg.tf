resource "aws_security_group" "main" {
  name        = "${var.properties.function_name}-lambda-sg"
  description = "Allow incoming traffic from entire vpc and open outgoing to entire vpc."
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Ingress from VPC to all ports and protocols."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "10.0.0.0/8"
    ]

  }

  egress {
    description = "Egress to world on all ports and protocols"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
