resource "aws_lb" "i_nlb" {
  count                      = var.create_lb_resources ? 1 : 0
  name                       = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-nlb"
  internal                   = true
  load_balancer_type         = "network"
  subnets                    = var.private_subnets
  idle_timeout               = var.i_nlb_idle_timeout
  enable_deletion_protection = var.lb_deletion_protection

  access_logs {
    enabled = var.nlb_access_logs_enabled
    bucket  = aws_s3_bucket.nlb_logs[count.index].bucket
    prefix  = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-nlb"
  }

  depends_on = [
    aws_s3_bucket_policy.nlb_logs,
    aws_s3_bucket_object.nlb_logs
  ]

  tags = var.tags
}

resource "aws_lb_listener" "i_nlb_443" {
  count             = var.create_lb_resources ? 1 : 0
  load_balancer_arn = aws_lb.i_nlb[0].arn
  port              = var.i_lbs_listener_port
  protocol          = var.i_nlb_listener_protocol

  default_action {
    target_group_arn = aws_lb_target_group.i_nlb_tg[0].arn
    type             = "forward"
  }
}