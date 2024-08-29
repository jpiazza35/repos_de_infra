module "istio_acm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env         = "devops"
  dns_zone_id = data.aws_route53_zone.selected.zone_id
  dns_name    = var.cluster_domain_name
  san = [
    var.env != "prod" ? "istio.${var.env}" : "istio",
  ]
  create_wildcard = true
  tags = {
    Environment    = var.env
    App            = "istio"
    Resource       = "Managed by Terraform"
    Description    = "DNS Related Configuration"
    Team           = "DevOps"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}
