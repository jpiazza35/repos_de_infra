# Create all private Route53 zones
resource "aws_route53_zone" "private" {
  for_each = {
    for zone in var.dns_zones_private : zone.ZoneDefinition.Name => zone
  }

  name          = each.value.ZoneDefinition.Name
  force_destroy = var.enable_force_destroy

  # Add VPC IDs for private zones
  dynamic "vpc" {
    for_each = concat([var.vpc_id], var.alternate_vpcs)

    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(
    var.tags,
    {
    }
  )
}

# Create all public Route53 zones
resource "aws_route53_zone" "public" {
  for_each = {
    for zone in var.dns_zones_public : zone.ZoneDefinition.Name => zone
  }

  name          = each.value.ZoneDefinition.Name
  force_destroy = var.enable_force_destroy

  tags = merge(
    var.tags,
    {
    }
  )
}

# Populate the private DNS zones
resource "aws_route53_record" "private" {
  for_each = {
    for record in local.dns_records_private :
    "${record.zone_name}.${record.record.Type}.${record.record.Name}%{if can(record.record.SetIdentifier)}.${record.record.SetIdentifier}%{endif}" => record
  }

  zone_id         = aws_route53_zone.private[each.value.zone_name].zone_id
  name            = each.value.record.Name
  type            = each.value.record.Type
  set_identifier  = try(each.value.record.SetIdentifier, null)
  ttl             = try(each.value.record.TTL, null)
  records         = try([for record in each.value.record.ResourceRecords : record.Value], null)
  health_check_id = try(each.value.record.Weight, null) != null && try(each.value.record.HealthCheckId, null) == "" ? aws_route53_health_check.private[each.key].id : try(each.value.record.HealthCheckId, null)
  allow_overwrite = var.allow_overwrite

  dynamic "alias" {
    for_each = {
      for key, value in each.value.record : key => value
      if key == "AliasTarget"
    }

    content {
      name                   = alias.value.DNSName
      zone_id                = alias.value.HostedZoneId
      evaluate_target_health = alias.value.EvaluateTargetHealth
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = {
      for key, value in each.value.record : key => value
      if key == "Weight"
    }

    content {
      weight = weighted_routing_policy.value
    }
  }
}

# Populate the public DNS zones
resource "aws_route53_record" "public" {
  for_each = {
    for record in local.dns_records_public :
    "${record.zone_name}.${record.record.Type}.${record.record.Name}%{if can(record.record.SetIdentifier)}.${record.record.SetIdentifier}%{endif}" => record
  }

  zone_id = aws_route53_zone.public[each.value.zone_name].zone_id
  name    = each.value.record.Name
  type    = each.value.record.Type

  set_identifier = try(each.value.record.SetIdentifier, null)

  ttl = try(each.value.record.TTL, null)

  records = try(
    [
      for record in each.value.record.ResourceRecords : record.Value
    ], null
  )

  health_check_id = try(each.value.record.Weight, null) != null && try(each.value.record.HealthCheckId, null) == "" ? aws_route53_health_check.public[each.key].id : try(each.value.record.HealthCheckId, null)

  allow_overwrite = var.allow_overwrite

  dynamic "alias" {
    for_each = {
      for key, value in each.value.record : key => value
      if key == "AliasTarget"
    }

    content {
      name                   = alias.value.DNSName
      zone_id                = alias.value.HostedZoneId
      evaluate_target_health = alias.value.EvaluateTargetHealth
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = {
      for key, value in each.value.record : key => value
      if key == "Weight"
    }

    content {
      weight = weighted_routing_policy.value
    }
  }
}

# Create parent records for private DNS sub-domains
resource "aws_route53_record" "private_children" {
  for_each = {
    for zone in var.dns_zones_private : zone.ZoneDefinition.Name => zone
    if zone.ZoneDefinition.Parent != null && zone.ZoneDefinition.Parent != ""
  }

  zone_id = aws_route53_zone.private[each.value.ZoneDefinition.Parent].zone_id
  name    = format("%s.", each.value.ZoneDefinition.Name)
  type    = "NS"
  ttl     = "86400"
  records = aws_route53_zone.private[each.value.ZoneDefinition.Name].name_servers

  depends_on = [aws_route53_zone.private]
}

# Create parent records for public DNS sub-domains
resource "aws_route53_record" "public_children" {
  for_each = {
    for zone in var.dns_zones_public : zone.ZoneDefinition.Name => zone
    if zone.ZoneDefinition.Parent != null && zone.ZoneDefinition.Parent != ""
  }

  zone_id = aws_route53_zone.public[each.value.ZoneDefinition.Parent].zone_id
  name    = format("%s.", each.value.ZoneDefinition.Name)
  type    = "NS"
  ttl     = "86400"
  records = aws_route53_zone.public[each.value.ZoneDefinition.Name].name_servers

  depends_on = [aws_route53_zone.public]
}
