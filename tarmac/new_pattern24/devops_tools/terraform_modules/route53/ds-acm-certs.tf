# resource "aws_acm_certificate" "ds_subdomains_certs" {
#   count             = var.create_ds_dns_resources ? length(var.ds_cards_records) : 0
#   domain_name       = "${var.ds_cards_records[count.index]}.${aws_route53_zone.ds_public[count.index].name}"
#   validation_method = "DNS"

#   options {
#     certificate_transparency_logging_preference = "ENABLED"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = merge(
#     {
#       Name = aws_route53_zone.ds_public[count.index].name
#     },
#     var.tags
#   )

#   # depends_on = [
#   #   aws_route53_record.ds_zone_ns_records
#   # ]
# }

# resource "aws_route53_record" "ds_subdomains_certs" {

#   for_each = {
#     for dvo in flatten([for cert in aws_acm_certificate.ds_subdomains_certs : cert.domain_validation_options]) : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.ds_public[0].id
# }

# resource "aws_acm_certificate_validation" "ds_subdomains_certs" {
#   count                   = var.create_ds_dns_resources ? length(var.ds_cards_records) : 0
#   certificate_arn         = aws_acm_certificate.ds_subdomains_certs[count.index].arn
#   validation_record_fqdns = [for record in aws_route53_record.ds_subdomains_certs : record.fqdn]
# }