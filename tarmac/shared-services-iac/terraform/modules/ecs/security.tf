resource "aws_security_group" "ecs_service" {
  vpc_id = coalesce(var.security_group["vpc_id"], data.aws_vpc.vpc.id)

  name = format("%s-%s-ecs-service-sg", lower(var.cluster["env"]), lower(var.cluster["app"]))

  description = "Fargate service security group"

  ingress {
    description = "Self from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block
    ]
  }

  dynamic "ingress" {
    for_each = [
      for ing in var.security_group["ingress"] : ing
      if ing.from_port != null && ing != null
    ]
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = "all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block,
      "0.0.0.0/0"
    ]
  }

  dynamic "egress" {
    for_each = [
      for eg in var.security_group["egress"] : eg
      if eg.from_port != null && eg != null
    ]
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(
    {
      Name = format("%s-%s-ecs-service-sg", lower(var.cluster["env"]), lower(var.cluster["app"]))
    },
    var.tags,
    {
      Environment    = var.cluster["env"]
      App            = var.cluster["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.cluster["app"]} Related Configuration"
      Team           = var.cluster["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )

  revoke_rules_on_delete = true

  lifecycle {
    create_before_destroy = true
  }
}
