resource "aws_alb" "load_balancer" {
  name = format("%s-%s-lb", lower(var.alb["env"]), lower(var.alb["app"]))

  load_balancer_type = var.alb["load_balancer_type"]

  dynamic "subnet_mapping" {
    for_each = toset(var.alb["subnets"] == null ? local.subnets : var.alb["subnets"])

    content {
      subnet_id     = subnet_mapping.value
      allocation_id = var.alb["create_static_public_ip"] ? aws_eip.lb[subnet_mapping.key].id : null
    }

  }

  security_groups = var.alb["create_security_group"] ? concat(
    var.alb["security_group"]["ids"],
    [
      aws_security_group.load_balancer_security_group.id
  ]) : []

  enable_deletion_protection = var.alb["enable_deletion_protection"]

  enable_cross_zone_load_balancing = var.alb["load_balancer_type"] == "network" ? var.alb["enable_cross_zone_load_balancing"] : false

  internal = var.alb["internal"]

  dynamic "access_logs" {
    for_each = var.alb["access_logs"]["enabled"] ? [var.alb["access_logs"]] : []
    content {
      bucket  = var.alb["access_logs"]["bucket"] == "" ? aws_s3_bucket.logs[0].id : var.alb["access_logs"]["bucket"]
      prefix  = var.alb["access_logs"]["prefix"] == "" ? format("%s-lb", var.alb["app"]) : var.alb["access_logs"]["prefix"]
      enabled = var.alb["access_logs"]["enabled"]
    }
  }

  tags = merge(
    {
      Name = format("%s-%s-lb", lower(var.alb["env"]), lower(var.alb["app"]))
    },
    var.alb["tags"],
    {
      Environment    = var.alb["env"]
      App            = var.alb["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.alb["app"]} Related Configuration"
      Team           = var.alb["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = var.alb["vpc_id"] == "" ? data.aws_vpc.vpc.id : var.alb["vpc_id"]

  name = format("%s-%s-lb-sg", lower(var.alb["env"]), lower(var.alb["app"]))

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
      for idx, ing in var.alb["security_group"]["ingress"] : idx => ing
      if ing != [] && ing != null
    }
    /* var.alb["security_group"]["ingress"] != null ? {
      for idx, ing in var.alb["security_group"]["ingress"]: idx => ing
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
      for idx, eg in var.alb["security_group"]["egress"] : idx => eg
      if eg != [] && eg != null
    }
    /* var.alb["security_group"]["egress"] != null ? {
      for idx, eg in var.alb["security_group"]["egress"]: idx => eg
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
      Name = format("%s-%s-lb-sg", lower(var.alb["env"]), lower(var.alb["app"]))
    },
    var.alb["tags"],
    {
      Environment    = var.alb["env"]
      App            = var.alb["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.alb["app"]} Related Configuration"
      Team           = var.alb["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

resource "aws_lb_listener" "listener" {
  for_each = {
    for l in var.alb["listeners"] : "${lower(l.protocol)}-${l.port}-${l.action_type}" => l
  }
  load_balancer_arn = aws_alb.load_balancer.arn
  port              = each.value.port
  protocol          = each.value.protocol
  certificate_arn   = each.value.acm_arn

  default_action {
    type = "forward"

    target_group_arn = each.value.target_group_arn == "" ? aws_lb_target_group.tg[local.tgs[0]].arn : each.value.target_group_arn
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
      Name = format("%s-%s-lb-listener", each.value.protocol, each.value.port)
    },
    var.alb["tags"],
    {
      Environment    = var.alb["env"]
      App            = var.alb["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.alb["app"]} Related Configuration"
      Team           = var.alb["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

resource "aws_lb_target_group" "tg" {
  for_each = {
    for tg in var.alb["target_groups"] : "${lower(tg.protocol)}-${tg.port}" => tg
  }
  name = format("%s-%s-lb-tg", lower(var.alb["env"]), lower(each.value.name_prefix))

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
      Name = format("%s-%s-lb-tg", lower(var.alb["env"]), lower(each.value.name_prefix))
    },
    var.alb["tags"],
    {
      Environment    = var.alb["env"]
      App            = var.alb["app"]
      Resource       = "Managed by Terraform"
      Description    = "${var.alb["app"]} Related Configuration"
      Team           = var.alb["team"]
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}
