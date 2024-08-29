
## SG for Sonatype Nexus EFS

resource "aws_security_group" "ecs_efs_2_sg" {
  count       = local.default
  vpc_id      = data.aws_vpc.vpc[0].id
  name        = "ecs_efs_nexus_sg"
  description = "Fargate service security group for EFS"

  ingress {
    description = "ALL from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc[0].cidr_block
    ]
  }

  ingress {
    description = "Allow all for EFS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    var.tags,
    {
      Name           = "ecs_efs_nexus_sg"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )

  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }
}

## SG for INCIDENT BOT EFS

resource "aws_security_group" "ecs_efs_incident_bot" {
  count       = local.default
  vpc_id      = data.aws_vpc.vpc[0].id
  name        = "ecs_efs_incident_bot_sg"
  description = "Fargate service security group for EFS"

  ingress {
    description = "ALL from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc[0].cidr_block
    ]
  }

  ingress {
    description = "Allow all for EFS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name           = "ecs_efs_incident_bot_sg"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )

  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }
}