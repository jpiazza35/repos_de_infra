# Create resolver security group
resource "aws_security_group" "inbound" {
  name        = "route53-inbound-acl"
  description = "Route53 Inbound Endpoints ACL."
  vpc_id      = var.vpc_id

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name             = "route53-inbound-acl",
      "cn:service"     = "security"
      "sourcecodeRepo" = "https://github.com/clinician-nexus/aws-networking"
    }
  )

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "outbound" {
  name        = "route53-outbound-acl"
  description = "Route53 Outbound Endpoints ACL."
  vpc_id      = var.vpc_id

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name             = "route53-outbound-acl",
      "cn:service"     = "security"
      "sourcecodeRepo" = "https://github.com/clinician-nexus/aws-networking"
    }
  )

  lifecycle {
    create_before_destroy = true
  }

}

# Resolvers
resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "inbound"
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.inbound.id
  ]

  dynamic "ip_address" {
    for_each = var.endpoint_subnets

    content {
      subnet_id = ip_address.value.id
    }
  }

  tags = merge(
    var.tags,
    {
      Name           = "inbound"
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )

}

resource "aws_route53_resolver_endpoint" "outbound" {
  name      = "outbound"
  direction = "OUTBOUND"

  security_group_ids = [
    aws_security_group.outbound.id
  ]

  dynamic "ip_address" {
    for_each = var.endpoint_subnets

    content {
      subnet_id = ip_address.value.id
    }
  }


  tags = merge(
    var.tags,
    {
      Name           = "outbound"
      sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
    }
  )

}

# Resolver rules
resource "aws_route53_resolver_rule" "forwarders" {
  for_each = var.forwarding_zones

  domain_name          = each.key
  name                 = replace(each.key, ".", "_")
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  dynamic "target_ip" {
    for_each = each.value

    content {
      ip = target_ip.value
    }
  }

  tags = merge(
    var.tags,
    {
      Name = replace(each.key, ".", "_")
    }
  )
}

# Outbound resolver rule RAM share
resource "aws_ram_resource_share" "outbound" {
  name                      = "route53-outbound-rules-share"
  allow_external_principals = false

  tags = merge(
    var.tags,
    {
    }
  )
}

resource "aws_ram_resource_association" "outbound" {
  for_each = aws_route53_resolver_rule.forwarders

  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.outbound.arn
}

resource "aws_ram_principal_association" "outbound" {
  principal          = var.org_arn
  resource_share_arn = aws_ram_resource_share.outbound.arn
}

