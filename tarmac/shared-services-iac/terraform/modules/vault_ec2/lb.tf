resource "aws_lb_target_group" "vault" {
  name     = "vault-tg"
  port     = 8200
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 3600
  }

  health_check {
    interval = 30
    path     = "/v1/sys/health"
    # https://www.vaultproject.io/api/system/health.html
    matcher  = "200,429,472,473"
    protocol = "HTTPS"
  }
}

resource "aws_lb_listener" "vault_lb_listener_http" {
  load_balancer_arn = var.alb_arn
  port              = "8201"
  protocol          = "HTTPS"
  certificate_arn   = var.acm_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault.arn
  }

}

resource "aws_lb_listener" "vault" {
  load_balancer_arn = var.alb_arn
  port              = 8200
  protocol          = "HTTPS"
  certificate_arn   = var.acm_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault.arn
  }
}
