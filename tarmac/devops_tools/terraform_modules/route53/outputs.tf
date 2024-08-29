output "env_public_dns_zone_id" {
  description = "The public Route53 zone ID per account/environment."
  value       = aws_route53_zone.public.*.id
}

output "env_public_dns_zone_name" {
  description = "The public Route53 zone name per account/environment."
  value       = aws_route53_zone.public.*.name
}

output "env_public_dns_zone_nameservers" {
  description = "The public Route53 zone NS records per account/environment."
  value       = aws_route53_zone.public.*.name_servers
}

output "app_public_dns_zone_id" {
  description = "The public Route53 zone ID per application."
  value       = aws_route53_zone.apps_public.*.id
}

output "app_public_dns_zone_name" {
  description = "The public Route53 zone name per application."
  value       = aws_route53_zone.apps_public.*.name
}

output "app_public_dns_zone_nameservers" {
  description = "The public Route53 zone NS records per application."
  value       = aws_route53_zone.apps_public.*.name_servers
}

output "ds_public_dns_zone_id" {
  description = "The public Route53 zone ID per DS."
  value       = aws_route53_zone.ds_public.*.id
}

output "ds_public_dns_zone_name" {
  description = "The public Route53 zone name per DS."
  value       = aws_route53_zone.ds_public.*.name
}

output "ds_public_dns_zone_nameservers" {
  description = "The public Route53 zone NS records per DS."
  value       = aws_route53_zone.ds_public.*.name_servers
}

output "internal_dns_zone_id" {
  description = "The private Route53 zone ID."
  value       = aws_route53_zone.internal.*.id
}

output "internal_dns_zone_name" {
  description = "The private Route53 zone name."
  value       = aws_route53_zone.internal.*.name
}

output "env_acm_public_certificate_arn" {
  description = "The ARN of the public AWS ACM certificate per account/environment."
  value       = aws_acm_certificate.payment_ch.*.arn
}

output "app_acm_public_certificate_arn" {
  description = "The ARN of the public AWS ACM certificate per application."
  value       = aws_acm_certificate.apps_subdomains_certs.*.arn
}

output "ds_acm_public_certificate_arn" {
  description = "The ARN of the public AWS ACM certificate per DS."
  value       = aws_acm_certificate.ds_subdomain_cert.*.arn
}

# output "ds_acm_public_certificates_arns" {
#   description = "The list of ARNs of the public card schemes ACM certificates."
#   value       = aws_acm_certificate.ds_subdomains_certs.*.arn
# }