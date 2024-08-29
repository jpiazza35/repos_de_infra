module "acm" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//acm?ref=v1.0.0"
  providers = {
    aws = aws
  }
  env         = "dev"
  dns_zone_id = ""
  dns_name    = "cliniciannexus.com"
  san = [
    "example"
  ]                       ## list of domain names that should be added to the certificate, if left blank only a wildcard cert will be created
  create_wildcard = false ## Should a wildcard certificate be created, if omitted, you must specify value(s) for the `san` variable
  tags = merge(
    var.tags,
    {
      Environment = "dev"
      App         = "ecs" ## Application/Product the DNS is for e.g. ecs, argocd
      Resource    = "Managed by Terraform"
      Description = "DNS Related Configuration"
      Team        = "DevOps" ## Name of the team requesting the creation of the DNS resource
    }
  )
}

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
