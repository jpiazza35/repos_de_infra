output "lb_security_group_id" {
  description = "ECS LB Security Group ID"
  value       = aws_security_group.load_balancer_security_group.id
}

output "alb_arn" {
  value = aws_alb.load_balancer.arn
}

output "lb_dns_name" {
  value = aws_alb.load_balancer.dns_name
}

output "lb_dns_zone" {
  value = aws_alb.load_balancer.zone_id
}

output "lb_zone_id" {
  value = aws_alb.load_balancer.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.tg[local.tgs[0]].arn
}
