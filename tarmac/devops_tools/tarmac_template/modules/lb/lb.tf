resource "aws_lb" "load_balancer" {
  name                       = var.load_balancer_name
  internal                   = var.load_balancer_internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [var.load_balancer_security_group_id]
  subnets                    = var.load_balancer_subnets
  enable_deletion_protection = var.load_balancer_deletion_protection

  access_logs {
    bucket  = var.load_balancer_log_bucket
    prefix  = var.load_balancer_log_prefix
    enabled = var.load_balancer_log_enabled
  }
  tags = var.tags
}

resource "aws_alb_target_group" "main" {
  name     = "ec2-tg-dev"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/swagger/"
    unhealthy_threshold = "2"
  }
  depends_on = [
    aws_lb.load_balancer
  ]
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_alb_target_group.main.arn
  target_id        = var.instance.id
  port             = 8080
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.id
  port              = 80
  protocol          = "HTTP"

  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = var.alb_tls_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}
