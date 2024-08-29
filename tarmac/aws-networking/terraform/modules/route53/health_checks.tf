# Create Health Checks
resource "aws_route53_health_check" "private" {
  for_each = {
    for record in local.dns_records_private : "${record.zone_name}.${record.record.Type}.${record.record.Name}%{if can(record.record.SetIdentifier)}.${record.record.SetIdentifier}%{endif}" => record

    if try(record.record.HealthCheckId, "") == "" && try(record.record.Weight, null) != null
  }

  reference_name = format("%s-healthcheck", each.value.record.SetIdentifier)
  disabled       = var.health_check_disabled
  /* fqdn = try(
        each.value.fqdn
        if !contains(record.Value, regex("[[:digit:]].[[:digit:]].[[:digit:]].[[:digit:]]"))
  , null) */

  ip_address = try(
    join(",",
      [
        for record in each.value.record.ResourceRecords : record.Value
        if contains([record.Value], regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", record.Value))
      ]
  ), null)

  port                            = var.health_check_port
  type                            = var.health_check_type
  resource_path                   = var.health_check_path
  failure_threshold               = "5"
  request_interval                = "30"
  search_string                   = var.health_check_type == "HTTP_STR_MATCH" || var.health_check_type == "HTTPS_STR_MATCH" ? var.health_check_search_string : null
  child_health_threshold          = var.health_check_type == "CALCULATED" ? 1 : null
  child_healthchecks              = var.health_check_type == "CALCULATED" ? var.child_health_checks : []
  cloudwatch_alarm_name           = var.health_check_type == "CLOUDWATCH_METRIC" ? var.cloudwatch_alarm_name : null
  cloudwatch_alarm_region         = var.health_check_type == "CLOUDWATCH_METRIC" ? data.aws_region.current.name : null
  insufficient_data_health_status = "Healthy"
  enable_sni                      = var.health_check_type == "HTTPS" ? true : false
  regions                         = null
  routing_control_arn             = var.health_check_type == "RECOVERY_CONTROL" ? var.routing_control_arn : null
  invert_healthcheck              = false
  measure_latency                 = false

  tags = {
    Name = format("%s-healthcheck", each.value.record.SetIdentifier)
  }
}

resource "aws_route53_health_check" "public" {
  for_each = var.health_check_disabled ? {} : {
    for record in local.dns_records_public : "${record.zone_name}.${record.record.Type}.${record.record.Name}%{if can(record.record.SetIdentifier)}.${record.record.SetIdentifier}%{endif}" => record

    if try(record.record.HealthCheckId, "") == "" && try(record.record.Weight, null) != null
  }

  reference_name = format("%s-healthcheck", each.value.record.SetIdentifier)

  disabled = var.health_check_disabled

  fqdn = try(
    join(",",
      [
        for record in each.value.record.ResourceRecords : record.Value
        if !contains(
          [record.Value], regex("[0-9]+.*", record.Value)
        )
      ]
  ), null)

  ip_address = try(
    join(",",
      [
        for record in each.value.record.ResourceRecords : record.Value
        if contains([record.Value], regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", record.Value))
      ]
  ), null)

  port                            = var.health_check_port
  type                            = var.health_check_type
  resource_path                   = var.health_check_path
  failure_threshold               = "5"
  request_interval                = "30"
  search_string                   = var.health_check_type == "HTTP_STR_MATCH" || var.health_check_type == "HTTPS_STR_MATCH" ? var.health_check_search_string : null
  child_health_threshold          = var.health_check_type == "CALCULATED" ? 1 : null
  child_healthchecks              = var.health_check_type == "CALCULATED" ? var.child_health_checks : []
  cloudwatch_alarm_name           = var.health_check_type == "CLOUDWATCH_METRIC" ? var.cloudwatch_alarm_name : null
  cloudwatch_alarm_region         = var.health_check_type == "CLOUDWATCH_METRIC" ? data.aws_region.current.name : null
  insufficient_data_health_status = "Healthy"
  enable_sni                      = var.health_check_type == "HTTPS" ? true : false
  regions                         = null
  routing_control_arn             = var.health_check_type == "RECOVERY_CONTROL" ? var.routing_control_arn : null
  invert_healthcheck              = false
  measure_latency                 = false


  tags = {
    Name           = format("%s-healthcheck", each.value.record.SetIdentifier)
    sourcecodeRepo = "https://github.com/clinician-nexus/aws-networking"
  }
}
