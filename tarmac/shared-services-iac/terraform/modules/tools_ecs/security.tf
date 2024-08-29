## PHPIPAM

resource "aws_security_group" "ecs_service" {
  count       = local.default
  vpc_id      = var.vpc_id
  name        = format("%s-ecs-service-sg", lower(var.env))
  description = "Fargate service security group"

  ingress {
    description = "ALL from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.vpc_cidr
    ]
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
      Name           = format("%s-ecs-service-sg-", lower(var.env))
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )

  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }
}

### Sonatype

resource "aws_security_group" "sonatype_ecs_service" {
  count       = local.default
  vpc_id      = var.vpc_id
  name        = format("%s-sonatype-ecs-service-sg", lower(var.env))
  description = "Fargate service security group for sonatype"

  ingress {
    description = "ALL from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      var.vpc_cidr
    ]
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
      Name           = format("%s-ecs-sonatype-service-sg-", lower(var.env))
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    },
  )

  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }
}
