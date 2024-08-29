output "lb_dns" {
  description = "The public ALB DNS name."
  value       = aws_lb.external.dns_name
}

output "lb_zone_id" {
  description = "The public ALB DNS zone ID."
  value       = aws_lb.external.zone_id
}