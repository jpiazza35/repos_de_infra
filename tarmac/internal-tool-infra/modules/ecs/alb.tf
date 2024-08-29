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
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "15"
    path                = each.value.healthcheck_path
    unhealthy_threshold = "2"
  }
  depends_on = [
    aws_lb.external,
  ]
}

resource "aws_alb_listener" "external" {
  for_each          = { for key, val in var.config_services : key => val if val.type == "public" }
  load_balancer_arn = aws_lb.external.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "external_https" {
  for_each = { for key, val in var.config_services : key => val if val.type == "public" }
  protocol = "HTTPS"
  port     = 443

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external[each.key].arn
  }

  load_balancer_arn = aws_lb.external.arn
  certificate_arn   = var.acm_certificate_arn
}
