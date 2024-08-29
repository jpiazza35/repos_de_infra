resource "aws_lb_target_group" "ecs-target-group" {
  name        = "ecs-${var.name}-${var.tags["env"]}" # constructed with all the vars used, name is in main.tf, env is in the tags
  port        = "8080"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
    protocol            = "HTTP"
    path                = "/login"
  }

  depends_on = [aws_lb.alb_ecs, aws_lb.i-alb_ecs]
}

resource "aws_lb_listener" "ecs_443" {
  load_balancer_arn = aws_lb.alb_ecs.arn
  port              = "443"
  protocol          = "HTTP"
  #certificate_arn   = var.aws_acm_certificate  # if https is needed, this needs to be commented out
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  default_action {
    target_group_arn = aws_lb_target_group.ecs-target-group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "ecs-listener-rule" {
  listener_arn = aws_lb_listener.ecs_443.arn # this is fetched from the remote state, since this listener is already created in a different repo
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target-group.arn
  }

  condition {
    host_header {
      values = ["${var.tags["env"]}.${var.public_dns}"] # rule forwards the request to a specific target group based on the DNS record
    }
  }
}