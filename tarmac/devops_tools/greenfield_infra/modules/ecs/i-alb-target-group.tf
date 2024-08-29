resource "aws_lb_target_group" "i-ecs-target-group" {
  name        = "i-ecs-${var.name}-${var.tags["env"]}"
  port        = "8080"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = "HTTP"
    path                = "/login"
  }

  depends_on = [aws_lb.alb_ecs, aws_lb.i-alb_ecs]
}

resource "aws_lb_listener" "i-ecs-443" {
  load_balancer_arn = aws_lb.i-alb_ecs.arn
  port              = "443"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.i-ecs-target-group.arn
    type             = "forward"
  }

}

resource "aws_lb_listener_rule" "i-ecs-listener-rule" {
  listener_arn = aws_lb_listener.i-ecs-443.arn # this is fetched from the remote state, since this listener is already created in a different repo
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.i-ecs-target-group.arn
  }

  condition {
    host_header {
      values = ["${var.tags["env"]}.${var.private_dns}"] # rule forwards the request to a specific target group based on the DNS record
    }
  }
}