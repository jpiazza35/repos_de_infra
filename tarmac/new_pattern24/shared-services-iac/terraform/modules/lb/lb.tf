resource "aws_lb" "load_balancer" {
  name = format("%s-%s-lb", lower(var.lb["env"]), lower(var.lb["app"]))

  load_balancer_type = var.lb["load_balancer_type"]

  dynamic "subnet_mapping" {
    for_each = toset(var.lb["subnets"] == null ? local.subnets : var.lb["subnets"])

    content {
      subnet_id     = subnet_mapping.value
      allocation_id = var.lb["create_static_public_ip"] ? aws_eip.lb[subnet_mapping.key].id : null
    }
  }

  security_groups = var.lb["create_security_group"] ? concat(
    var.lb["security_group"]["ids"],
    [
      aws_security_group.load_balancer_security_group.id
  ]) : []

  enable_deletion_protection       = var.lb["enable_deletion_protection"]
  enable_cross_zone_load_balancing = var.lb["load_balancer_type"] == "network" ? var.lb["enable_cross_zone_load_balancing"] : false
  internal                         = var.lb["internal"]

  dynamic "access_logs" {
    for_each = var.lb["access_logs"]["enabled"] ? [var.lb["access_logs"]] : []
    content {
      bucket  = var.lb["access_logs"]["bucket"] == "" ? aws_s3_bucket.logs[0].id : var.lb["access_logs"]["bucket"]
      prefix  = var.lb["access_logs"]["prefix"] == "" ? format("%s-lb", var.lb["app"]) : var.lb["access_logs"]["prefix"]
      enabled = var.lb["access_logs"]["enabled"]
    }
  }

  tags = merge(
    {
      Name = format("%s-%s-lb", lower(var.lb["env"]), lower(var.lb["app"]))
    },
    var.lb["tags"],
  )
}

resource "aws_lb_target_group" "tg" {
  for_each = var.lb.routes

  name = format("%s-%s-%s-tg", lower(var.lb["env"]), each.key, lower(each.value.target_group.name_prefix))

  vpc_id                             = each.value.target_group.vpc_id == "" ? data.aws_vpc.vpc.id : each.value.target_group.vpc_id
  protocol                           = each.value.target_group.protocol
  port                               = each.value.target_group.port
  deregistration_delay               = each.value.target_group.deregistration_delay
  load_balancing_cross_zone_enabled  = each.value.target_group.load_balancing_cross_zone_enabled
  lambda_multi_value_headers_enabled = each.value.target_group.lambda_multi_value_headers_enabled
  protocol_version                   = each.value.target_group.protocol_version
  target_type                        = each.value.target_group.target_type

  dynamic "health_check" {
    for_each = [each.value.target_group.health_check]
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
      Name = format("%s-%s-%s-tg", lower(var.lb["env"]), each.key, lower(each.value.target_group.name_prefix))
    },
    var.lb["tags"],
    each.value.target_group["tags"]
  )
}

resource "aws_lb_listener" "listener" {
  for_each = var.lb.routes

  load_balancer_arn = aws_lb.load_balancer.arn
  port              = each.value.listener.port
  protocol          = each.value.listener.protocol
  certificate_arn   = each.value.listener.acm_arn

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }

  dynamic "default_action" {
    for_each = var.default_actions.fixed_response.create ? try([var.default_actions.fixed_response], []) : []

    iterator = fixed_response

    content {
      type = fixed_response.value.type

      fixed_response {
        content_type = fixed_response.value.content_type
        message_body = fixed_response.value.message_body
        status_code  = fixed_response.value.status_code
      }
    }
  }

  dynamic "default_action" {
    for_each = var.default_actions.redirect.create ? try([var.default_actions.redirect], []) : []

    iterator = redirect
    content {
      type = redirect.value.type
      redirect {
        port        = redirect.value.port
        protocol    = redirect.value.protocol
        status_code = redirect.value.status_code
      }
    }
  }

  tags = merge(
    {
      Name = format("%s-%s-%s-lstnr", each.key, each.value.listener.protocol, each.value.listener.port)
    },
    var.lb["tags"],
    each.value.listener["tags"]
  )
}

