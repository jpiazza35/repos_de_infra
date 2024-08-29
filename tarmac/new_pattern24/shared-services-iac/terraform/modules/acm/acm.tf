resource "aws_acm_certificate" "cert" {
  provider = aws

  domain_name = var.create_wildcard ? format("*.%s", local.use_local_dns_name) : format("%s.%s", var.san[0], local.use_local_dns_name)

  subject_alternative_names = (var.create_wildcard && var.san != []) || (!var.create_wildcard && length(var.san) > 1) ? [
    for s in var.san : format("%s.%s", s, local.use_local_dns_name)
  ] : null

  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
