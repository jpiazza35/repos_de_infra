/* -------- SECURITY SG-------- */
resource "aws_security_group" "private" {
  name        = "private"
  description = "Intra VPC Traffic for Private Subnets"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      aws_vpc.vpc.cidr_block,
    ]
    description = "VPCE to private subnets"
  }

  dynamic "ingress" {
    for_each = var.enable_secondary_cidr ? [
      aws_vpc_ipv4_cidr_block_association.secondary_cidr[0].cidr_block
    ] : []
    content {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = [
        ingress.value
      ]
      description = "VPCE to Local Subnets"
    }
  }

  dynamic "ingress" {
    for_each = var.enable_secondary_cidr && length(data.aws_vpc.vpc.cidr_block_associations) > 2 ? [
      for cidr in data.aws_vpc.vpc.cidr_block_associations : cidr.cidr_block
      if cidr.cidr_block != aws_vpc.vpc.cidr_block && cidr.cidr_block != aws_vpc_ipv4_cidr_block_association.secondary_cidr[0].cidr_block
    ] : []
    content {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = [
        ingress.value
      ]
      description = "VPCE to secondary subnets"
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      aws_vpc.vpc.cidr_block,
    ]
    description = "VPCE to private subnets"
  }

  dynamic "egress" {
    for_each = var.enable_secondary_cidr ? [
      aws_vpc_ipv4_cidr_block_association.secondary_cidr[0].cidr_block
    ] : []
    content {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = [
        egress.value
      ]
      description = "VPCE to Local Subnets"
    }
  }

  dynamic "egress" {
    for_each = var.enable_secondary_cidr && length(data.aws_vpc.vpc.cidr_block_associations) > 2 ? [
      for cidr in data.aws_vpc.vpc.cidr_block_associations : cidr.cidr_block
      if cidr.cidr_block != aws_vpc.vpc.cidr_block && cidr.cidr_block != aws_vpc_ipv4_cidr_block_association.secondary_cidr[0].cidr_block
    ] : []
    content {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = [
        egress.value
      ]
      description = "VPCE to secondary subnets"
    }
  }


  tags = merge(
    var.tags,
    {
      Name           = "private"
      SourceCodeRepo = "https://github.com/clinician-nexus/aft-account-customizations"
    }
  )
}
