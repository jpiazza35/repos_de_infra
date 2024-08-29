resource "aws_lb" "external" {
  name                       = "${var.environment}-ecs-public-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.external_lb_sg.id]
  subnets                    = var.public_subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "external" {
  for_each    = { for key, val in var.config_services : key => val if val.type == "public" }
  name_prefix = each.value.target_group_prefix
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
    aws_lb.external,
  ]
}

resource "aws_alb_listener" "external" {
  load_balancer_arn = aws_lb.external.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is an ALB."
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "external" {
  for_each     = { for key, val in var.config_services : key => val if val.type == "public" }
  listener_arn = aws_alb_listener.external.id
  priority     = 100 + index(keys(var.config_services), each.key)

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external[each.key].arn
  }

  condition {
    path_pattern {
      values = [
        "/api/*"
      ]
    }
  }

  depends_on = [
    aws_lb_target_group.external
  ]
}
