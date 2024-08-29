# These resources here can be created and used when the we have the DNS client domain hosted in AWS. If the domain is in another provider GoDaddy, Cloudflare etc. then some other
# configurations are required in order for this certificate to be validatad inside AWS ACM service.

# resource "aws_acm_certificate" "public" {
#   domain_name       = "*.${var.public_dns}"
#   validation_method = "DNS"

#   tags = {
#     Name        = "${var.public_dns}"
#     Environment = "${var.tags["env"]}"
#     Repository  = "${var.tags["repository"]}"
#     Script      = "${var.tags["script"]}"
#     Service     = "${var.tags["service"]}"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "cert_validation" {
#   name    = aws_acm_certificate.public.domain_validation_options.0.resource_record_name
#   type    = aws_acm_certificate.public.domain_validation_options.0.resource_record_type
#   zone_id = aws_route53_zone.public.id
#   records = [aws_acm_certificate.public.domain_validation_options.0.resource_record_value]
#   ttl     = 60
# }

# # Used to validate cert but takes and 15mins and TF will not complete it gets a response
# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = "${aws_acm_certificate.public.arn}"
#   validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
# }