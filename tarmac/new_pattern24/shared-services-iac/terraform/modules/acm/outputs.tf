output "acm" {
  value = var.dns_name != "" ? aws_acm_certificate.cert.arn : null
}

output "cert" {
  value = var.dns_name != "" ? aws_acm_certificate.cert : null
}

output "acm_dvo" {
  value = var.dns_name != "" ? aws_acm_certificate.cert.domain_validation_options : null
}

output "arn" {
  value = var.dns_name != "" ? aws_acm_certificate.cert.arn : null
}
