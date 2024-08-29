output "subnet_private_id" {
  description = "Private subnets id"
  value       = aws_subnet.subnet_private.*.id
}
output "subnet_public_id" {
  description = "Public subnets id"
  value       = aws_subnet.subnet_public.*.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "default_security_group_id" {
  value = aws_security_group.default_vpc_segurity_group.id
}

output "redis_security_group_id" {
  value = aws_security_group.redis_vpc_segurity_group.id
}

output "public_dns_zone_name" {
  value = aws_route53_zone.public.name
}

output "public_dns_zone_id" {
  value = aws_route53_zone.public.id
}

output "internal_dns_zone_name" {
  value = aws_route53_zone.internal.name
}

output "internal_dns_zone_id" {
  value = aws_route53_zone.internal.id
}