resource "aws_route53_record" "ecs-private" {
  zone_id = var.private_r53
  name    = "${var.tags["env"]}.${var.private_dns}"
  type    = "A"

  alias {
    name                   = aws_lb.i-alb_ecs.dns_name
    zone_id                = aws_lb.i-alb_ecs.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ecs-public" {
  zone_id = var.public_r53
  name    = "${var.tags["env"]}.${var.public_dns}"
  type    = "A"

  alias {
    name                   = aws_lb.alb_ecs.dns_name
    zone_id                = aws_lb.alb_ecs.zone_id
    evaluate_target_health = false
  }
}
