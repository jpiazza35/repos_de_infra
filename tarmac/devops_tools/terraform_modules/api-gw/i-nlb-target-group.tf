resource "aws_lb_target_group" "i_nlb_tg" {
  count       = var.create_lb_resources ? 1 : 0
  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-internal-nlb-tg"
  port        = var.i_nlb_target_group_port
  protocol    = var.i_nlb_target_group_protocol
  target_type = "alb"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    protocol            = var.i_alb_listener_protocol
  }

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "i_nlb_tg" {
  count            = var.create_lb_resources ? 1 : 0
  target_group_arn = aws_lb_target_group.i_nlb_tg[count.index].arn
  target_id        = aws_lb.i_alb[count.index].arn
  port             = var.i_nlb_target_group_port
}