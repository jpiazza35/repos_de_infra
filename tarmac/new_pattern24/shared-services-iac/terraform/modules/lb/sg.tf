resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = var.lb["vpc_id"] == "" ? data.aws_vpc.vpc.id : var.lb["vpc_id"]

  name = format("%s-%s-lb-sg", lower(var.lb["env"]), lower(var.lb["app"]))

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
    for_each = {
      for idx, ing in var.lb["security_group"]["ingress"] : idx => ing
      if ing != [] && ing != null
    }
    /* var.lb["security_group"]["ingress"] != null ? {
      for idx, ing in var.lb["security_group"]["ingress"]: idx => ing
      if ing != [] && ing != null
    } : {} */
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
    for_each = {
      for idx, eg in var.lb["security_group"]["egress"] : idx => eg
      if eg != [] && eg != null
    }
    /* var.lb["security_group"]["egress"] != null ? {
      for idx, eg in var.lb["security_group"]["egress"]: idx => eg
      if eg != [] && eg != null
    } : {} */
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  lifecycle {
    ignore_changes = [
      /* ingress */
    ]
  }

  tags = merge(
    {
      Name = format("%s-%s-lb-sg", lower(var.lb["env"]), lower(var.lb["app"]))
    },
    var.lb["tags"]
  )
}
