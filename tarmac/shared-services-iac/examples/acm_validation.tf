module "acm_validation" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm_validation?ref=v1.0.0"
  providers = {
    aws.ss_network = aws.ss_network
  }
  depends_on = [
    module.acm
  ]
  env         = "dev"
  dns_name    = "cliniciannexus.com"
  dns_zone_id = ""
  cert        = module.acm.cert
}

resource "aws_acm_certificate_validation" "validate" {
  certificate_arn         = module.acm.acm
  validation_record_fqdns = module.acm_validation.fqdns
}
