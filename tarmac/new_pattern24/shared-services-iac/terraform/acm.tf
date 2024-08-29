## PHPIPAM

module "acm" {
  source = "./modules/acm"
  providers = {
    aws = aws
  }
  dns_name = "cliniciannexus.com"
  san = [
    "phpipam"
  ]
  dns_zone_id     = module.dns.zone_id
  create_wildcard = false
  env             = var.env
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "acm"
      Resource       = "Managed by Terraform"
      Description    = "Certificate Management Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

module "acm_validation" {
  source = "./modules/acm_validation"
  providers = {
    aws.ss_network = aws.ss_network
  }
  env         = var.env
  dns_name    = "cliniciannexus.com"
  dns_zone_id = ""
  cert        = module.acm.cert
}


## Sonatype Artifactory

module "sonatype_acm" {
  source = "./modules/acm"
  providers = {
    aws = aws
  }
  env      = var.env
  dns_name = "cliniciannexus.com"
  san = [
    "sonatype"
  ]
  dns_zone_id     = module.sonatype_dns.zone_id
  create_wildcard = false
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "acm"
      Resource       = "Managed by Terraform"
      Description    = "Certificate Management Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

module "sonatype_acm_validation" {
  source = "./modules/acm_validation"
  providers = {
    aws.ss_network = aws.ss_network
  }
  env         = var.env
  dns_name    = "cliniciannexus.com"
  dns_zone_id = ""
  cert        = module.sonatype_acm.cert
}

## INCIDENT BOT
module "incident_bot_acm" {
  source = "./modules/acm"
  providers = {
    aws = aws
  }
  env      = var.env
  dns_name = "cliniciannexus.com"
  san = [
    "incident-bot"
  ]
  dns_zone_id     = "" #module.incident_bot_dns.zone_id
  create_wildcard = false
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "acm"
      Resource       = "Managed by Terraform"
      Description    = "Certificate Management Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
}

module "incident_bot_acm_validation" {
  source = "./modules/acm_validation"
  providers = {
    aws.ss_network = aws.ss_network
  }
  env         = var.env
  dns_name    = "cliniciannexus.com"
  dns_zone_id = ""
  cert        = module.incident_bot_acm.cert
}
