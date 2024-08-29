
resource "aws_security_group" "eks_node_group_sg" {
  #checkov:skip=CKV2_AWS_5
  name        = "${var.cluster_name}-worker-nodes-sg"
  description = "Custom security group for worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "allow all ports between nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description      = "Allow all egress traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ## Webhook of ALB can't reach the control plane without this rule
  ingress {
    description = "allow all ports from the control plane"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
