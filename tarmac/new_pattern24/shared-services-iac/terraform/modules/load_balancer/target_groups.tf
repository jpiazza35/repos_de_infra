resource "aws_lb_target_group" "tg" {
  for_each = {
    for tg in var.lb["target_groups"] : "${lower(tg.protocol)}-${tg.port}" => tg
  }
  name = format("%s-%s-lb-tg", lower(var.lb["env"]), lower(each.value.name_prefix))

  vpc_id = each.value.vpc_id == "" ? data.aws_vpc.vpc.id : each.value.vpc_id

  protocol = each.value.protocol
  port     = each.value.port

  deregistration_delay = each.value.deregistration_delay

  load_balancing_cross_zone_enabled = each.value.load_balancing_cross_zone_enabled

  lambda_multi_value_headers_enabled = each.value.lambda_multi_value_headers_enabled

  protocol_version = each.value.protocol_version

  target_type = each.value.target_type

  dynamic "health_check" {
    for_each = [each.value.health_check]
    content {
      enabled             = health_check.value.enabled
      interval            = health_check.value.interval
      path                = health_check.value.path
      port                = health_check.value.port
      protocol            = health_check.value.protocol
      timeout             = health_check.value.timeout
      healthy_threshold   = health_check.value.healthy_threshold
      unhealthy_threshold = health_check.value.unhealthy_threshold
      matcher             = health_check.value.matcher
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = format("%s-%s-lb-tg", lower(var.lb["env"]), lower(each.value.name_prefix))
    },
    var.lb["tags"],
    {
      Environment    = var.lb["env"]
      App            = var.lb["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.lb["app"]} Related Configuration"
      Team           = var.lb["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}
