resource "aws_vpc_endpoint" "workspace" {

  vpc_id            = var.vpc_id
  service_name      = local.private_link.workspace_service
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.databricks_private_link.id
  ]
  subnet_ids = var.private_subnet_ids[0]

  private_dns_enabled = true

  tags = {
    Name           = "databricks-workspace-vpce"
    SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
  }
}

resource "aws_vpc_endpoint" "relay" {

  vpc_id            = var.vpc_id
  service_name      = local.private_link.relay_service
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.databricks_private_link.id
  ]
  subnet_ids          = var.private_subnet_ids[0]
  private_dns_enabled = true

  tags = {
    Name           = "databricks-scc-vpce"
    SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
  }
}

resource "aws_route53_zone" "private" {

  provider = aws.ss_network
  name     = format("cn-%s.cloud.databricks.com", local.prefix)
  comment  = format("%s_%s Hosted Zone for %s", upper(substr(var.env, 0, 1)), upper(var.app), aws_vpc_endpoint.workspace.id)

  vpc {
    vpc_id = var.ss_network_vpc_ids[0]
  }

  lifecycle {
    ignore_changes = [
      vpc
    ]
  }
}

resource "aws_route53_record" "r53_alias_vpc_endpoint" {

  provider = aws.ss_network
  zone_id  = aws_route53_zone.private.zone_id
  name     = format("cn-%s.cloud.databricks.com", local.prefix)
  type     = "A"

  alias {
    name                   = aws_vpc_endpoint.workspace.dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.workspace.dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }

}

resource "aws_route53_resolver_rule" "fwd" {
  provider             = aws.ss_network
  domain_name          = format("cn-%s.cloud.databricks.com.", local.prefix)
  name                 = format("cn_%s_cloud_databricks_com", local.prefix)
  rule_type            = "FORWARD"
  resolver_endpoint_id = data.aws_route53_resolver_endpoint.rre.id

  target_ip {
    ip   = "10.200.11.33"
    port = 53
  }

  target_ip {
    ip   = "10.200.12.33"
    port = 53
  }

  tags = merge(
    var.tags,
    {
      Name = format("cn-%s_cloud_databricks_com.", local.prefix)
    }
  )
}

resource "aws_route53_resolver_rule_association" "rrra" {
  provider         = aws.ss_network
  for_each         = toset(var.ss_network_vpc_ids)
  resolver_rule_id = aws_route53_resolver_rule.fwd.id
  vpc_id           = each.value
}
