output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}
output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}
output "cidr_blocks" {
  value = aws_vpc.vpc.cidr_block
}
output "r53_private" {
  value = aws_route53_zone.phz.zone_id
}
output "r53_public" {
  value = aws_route53_zone.public.zone_id
}
