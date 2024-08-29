# Internal, private ALB that will handle requests towards the applications
resource "aws_lb" "i_alb" {
  count                      = var.create_lb_resources ? 1 : 0
  name                       = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-alb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg_i_alb[0].id]
  subnets                    = var.private_subnets
  idle_timeout               = var.i_alb_idle_timeout
  enable_deletion_protection = var.lb_deletion_protection

  access_logs {
    enabled = var.alb_access_logs_enabled
    bucket  = aws_s3_bucket.alb_logs[count.index].bucket
    prefix  = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-alb"
  }

  depends_on = [
    aws_s3_bucket_policy.alb_logs,
    aws_s3_bucket_object.alb_logs
  ]

  tags = var.tags
}

resource "aws_lb_listener" "i_alb_443" {
  count             = var.create_lb_resources ? 1 : 0
  load_balancer_arn = aws_lb.i_alb[0].arn
  port              = var.i_lbs_listener_port
  protocol          = var.i_alb_listener_protocol

  certificate_arn = var.app_acm_public_certificate_arn
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is an ALB."
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_certificate" "i_alb_443" {
  count = var.add_server_lb_certificate ? 1 : 0

  listener_arn    = var.i_alb_listener_arn
  certificate_arn = var.app_acm_public_certificate_arn
}

# resource "aws_lb_listener_certificate" "i_alb_ds" {
#   count = var.create_ds_dns_resources ? length(var.ds_cards_records) : 0

#   listener_arn    = var.i_alb_listener_arn
#   certificate_arn = var.ds_acm_public_certificates_arns[count.index]
# }
