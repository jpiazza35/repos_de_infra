resource "aws_lb_target_group" "i_ecs" {
  count       = var.create_internal_lb ? 1 : 0
  name        = "my-example-alb-tg"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = "ip"
  vpc_id      = var.vpc_id

  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 4
    interval            = 50
    protocol            = var.target_group_protocol
    path                = var.target_group_health_check_path
  }

  tags = var.tags
}

resource "aws_lb_listener_rule" "i_alb_public_listener_rule" {
  count        = var.create_alb_public_listener_rule ? length(var.shared_ecs_service_client_list) : 0
  listener_arn = var.i_alb_listener_arn
  priority     = var.i_alb_public_listener_rule_priority + count.index

  action {
    type             = "forward"
    target_group_arn = element(concat(aws_lb_target_group.i_ecs.*.arn, tolist([""])), 0)
  }

  condition {
    http_header {
      http_header_name = "X-Forwarded-Host"
      values           = ["${var.shared_ecs_service_client_list[count.index]}.${var.tags["Application"]}.${var.env_public_dns_name}"]
    }
  }

  depends_on = [
    aws_lb_target_group.i_ecs
  ]
}

resource "aws_lb_listener_rule" "i_alb_ds_listener_rule" {
  count        = var.create_alb_ds_listener_rule ? length(var.shared_ecs_service_client_uuids) : 0
  listener_arn = var.i_alb_listener_arn
  priority     = var.i_alb_ds_listener_rule_priority + count.index

  action {
    type             = "forward"
    target_group_arn = element(concat(aws_lb_target_group.i_ecs.*.arn, tolist([""])), 0)
  }

  condition {
    query_string {
      key   = "orgId"
      value = var.shared_ecs_service_client_uuids[count.index]
    }
  }

  depends_on = [
    aws_lb_target_group.i_ecs
  ]
}
