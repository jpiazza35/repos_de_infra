output "zone_id" {
  value = var.create_local_zone && terraform.workspace != "default" ? aws_route53_zone.local_zone[0].zone_id : null
}

output "zone_name" {
  value = var.create_local_zone && terraform.workspace != "default" ? aws_route53_zone.local_zone[0].name : null
}
