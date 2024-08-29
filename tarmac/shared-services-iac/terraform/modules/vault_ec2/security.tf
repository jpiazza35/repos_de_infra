### Security Groups
resource "aws_security_group" "vault" {
  count       = local.default
  name        = "hcp_vault"
  description = "Allow HCP Vault Traffic"
  vpc_id      = data.aws_vpc.vpc[count.index].id

  ingress {
    description = "VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc[count.index].cidr_block
    ]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = "hcp_vault"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}

resource "aws_security_group_rule" "asg_app_admin_rule" {
  count       = local.default
  type        = "ingress"
  from_port   = 8200
  to_port     = 8600
  protocol    = "tcp"
  description = "Vault Access to ASG"
  cidr_blocks = [
    "0.0.0.0/0",
    /* "10.0.0.0/8" */
  ]
  security_group_id = var.alb_sg_id
}
