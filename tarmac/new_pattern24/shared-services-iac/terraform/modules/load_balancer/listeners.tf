resource "aws_lb_listener" "listener" {
  for_each = {
    for l in var.lb["listeners"] : "${lower(l.protocol)}-${l.port}-${l.action_type}" => l
  }
  load_balancer_arn = aws_lb.load_balancer.arn
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
