locals {

  acm_domain_validation_option = tolist(aws_acm_certificate.cert.domain_validation_options)

  dns_name = var.env == "dev" ? "dev.cliniciannexus.com" : var.env == "qa" ? "qa.cliniciannexus.com" : var.env == "prod" ? "cliniciannexus.com" : var.env == "SS" ? "cliniciannexus.com" : var.env == "devops" ? "cliniciannexus.com" : "cliniciannexus.com"

  use_local_dns_name = var.dns_name == "" ? local.dns_name : var.dns_name
}
