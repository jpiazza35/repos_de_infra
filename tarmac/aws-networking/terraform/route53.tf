# Add the route53 configuration
module "route53" {
  source = "./modules/route53"

  for_each = terraform.workspace == "tgw" ? toset(["us-east-1"]) : toset([])

  endpoint_subnets = module.vpc-primary.private_subnets
  vpc_id           = module.vpc-primary.vpc.id
  alternate_vpcs = [
    module.vpc-inspection-internet["us-east-1"].vpc.id,
    module.vpc-inspection-internal["us-east-1"].vpc.id
  ] # Alternative VPCs where certain resources need to exist (Private DNS Zones)
  env                  = "shared_services"
  forwarding_zones     = var.route53_forwarding_zones # Forward these zones to other DNS servers.
  org_arn              = data.aws_organizations_organization.current.arn
  dns_zones_public     = local.dns_zones_public
  dns_zones_private    = local.dns_zones_private
  enable_force_destroy = true # This should be fully managed by Terraform. Any thing not managed by TF will be destroyed.
  allow_overwrite      = true

  tags = merge(
    var.tags,
    {
      "cn:description" = "Route53 Configuration"
      "cn:service"     = "infrastructure"
    }
  )

}

# Create resolver security group
resource "aws_security_group" "inbound" {
  count       = terraform.workspace == "tgw-ohio" ? 1 : 0
  name        = "route53-inbound-acl"
  description = "Route53 Inbound Endpoints ACL."
  vpc_id      = module.vpc-primary.vpc.id

  egress {
    description = "Allow DNS (TCP) queries to the internet."
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow DNS (UDP) queries to the internet."
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name         = "route53-inbound-acl",
      "cn:service" = "security"
    }
  )

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "outbound" {
  count       = terraform.workspace == "tgw-ohio" ? 1 : 0
  name        = "route53-outbound-acl"
  description = "Route53 Outbound Endpoints ACL."
  vpc_id      = module.vpc-primary.vpc.id

  egress {
    description = "Allow DNS (TCP) queries to the internet."
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow DNS (UDP) queries to the internet."
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name         = "route53-outbound-acl",
      "cn:service" = "security"
    }
  )

  lifecycle {
    create_before_destroy = true
  }

}

# Resolvers
resource "aws_route53_resolver_endpoint" "inbound" {
  count     = terraform.workspace == "tgw-ohio" ? 1 : 0
  name      = "inbound"
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.inbound[count.index].id
  ]

  dynamic "ip_address" {
    for_each = module.vpc-primary.private_subnets

    content {
      subnet_id = ip_address.value.id
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "inbound"
    }
  )

}

resource "aws_route53_resolver_endpoint" "outbound" {
  count     = terraform.workspace == "tgw-ohio" ? 1 : 0
  name      = "outbound"
  direction = "OUTBOUND"

  security_group_ids = [
    aws_security_group.outbound[count.index].id
  ]

  dynamic "ip_address" {
    for_each = module.vpc-primary.private_subnets

    content {
      subnet_id = ip_address.value.id
    }
  }


  tags = merge(
    var.tags,
    {
      Name = "outbound"
    }
  )

}

# Resolver rules
resource "aws_route53_resolver_rule" "forwarders" {
  for_each = terraform.workspace == "tgw-ohio" ? var.route53_forwarding_zones : {}

  domain_name          = each.key
  name                 = replace(each.key, ".", "_")
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound[0].id

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
  count                     = terraform.workspace == "tgw-ohio" ? 1 : 0
  name                      = "route53-outbound-rules-share"
  allow_external_principals = false

  tags = merge(
    var.tags,
    {
    }
  )
}

resource "aws_ram_resource_association" "outbound" {
  for_each = terraform.workspace == "tgw-ohio" ? aws_route53_resolver_rule.forwarders : {}

  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.outbound[0].arn
}

resource "aws_ram_principal_association" "outbound" {
  count              = terraform.workspace == "tgw-ohio" ? 1 : 0
  principal          = var.org_arn
  resource_share_arn = aws_ram_resource_share.outbound[0].arn
}

