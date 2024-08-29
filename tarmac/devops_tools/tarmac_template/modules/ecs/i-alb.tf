resource "aws_lb" "internal" {
  name                       = "${var.environment}-ecs-internal-lb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.internal_lb_sg.id]
  subnets                    = var.private_subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "internal" {
  for_each    = { for key, val in var.config_services : key => val if val.type != "worker" }
  name_prefix = "i${each.value.target_group_prefix}"
  port        = each.value.taskDefinitionValues["container_port"]
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "2"
    interval            = "60"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "50"
    path                = each.value.healthcheck_path
    unhealthy_threshold = "2"
  }
  depends_on = [
    aws_lb.internal,
  ]
}

resource "aws_alb_listener" "internal" {
  load_balancer_arn = aws_lb.internal.id
  port              = 8000
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is an ALB."
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "internal_backend" {
  for_each     = { for key, val in var.config_services : key => val if val.type != "worker" }
  listener_arn = aws_alb_listener.internal.id
  priority     = 200 + index(keys(var.config_services), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal[each.key].arn
  }

  condition {
    http_header {
      http_header_name = "X-Forwarded-Host"
      values           = ["${each.value.service}.${var.internal_dns_zone_name}"]
    }
  }

  depends_on = [
    aws_lb_target_group.internal
  ]
}
