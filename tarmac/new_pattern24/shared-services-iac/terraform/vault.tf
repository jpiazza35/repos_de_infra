module "vault" {
  source    = "./modules/vault_ec2"
  app       = "vault"
  env       = "shared_services"
  alb_arn   = module.ecs.alb_arn
  acm_arn   = module.vault_acm.acm
  vpc_id    = data.aws_vpc.vpc[0].id
  alb_sg_id = module.ecs.lb_security_group_id
  tags = merge(
    var.tags,
    {
      Environment = var.env
      App         = "ecs"
      Resource    = "Managed by Terraform"
      Description = "ECS Related Configuration"
      Team        = "DevOps"
    }
  )
}

module "vault_acm" {
  source = "./modules/acm"
  providers = {
    aws = aws
  }
  env      = var.env
  dns_name = "cliniciannexus.com"
  san = [
    "vault",
  ]
  dns_zone_id     = module.dns.zone_id
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

module "vault_acm_validation" {
  source = "./modules/acm_validation"
  providers = {
    aws.ss_network = aws.ss_network
  }
  env         = var.env
  dns_name    = "cliniciannexus.com"
  dns_zone_id = ""
  cert        = module.vault_acm.cert
}

module "vault_dns" {
  source = "./modules/dns"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env               = var.env
  vpc_id            = data.aws_vpc.vpc[0].id
  lb_dns_name       = module.ecs.lb_dns_name
  lb_dns_zone       = module.ecs.lb_dns_zone
  dns_name          = "cliniciannexus.com"
  create_local_zone = true
  record_prefix = [
    "vault",
  ]
  tags = merge(
    var.tags,
    {
      Environment    = var.env
      App            = "ecs"
      Resource       = "Managed by Terraform"
      Description    = "DNS Related Configuration"
      Team           = "DevOps"
      SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
    }
  )
  depends_on = [
    module.vault_acm
  ]
}

module "vault_kms" {
  source = "./modules/kms"
  app    = "vault"
  env    = var.env
}

module "vault_backup" {
  source            = "./modules/backups"
  app               = "ss-tools"
  env               = var.env
  enabled           = true
  vault_kms_key_arn = module.vault_kms.kms_key_arn
  selection_name    = lower(var.env)
  tags = {
    Environment    = var.env
    App            = "ss-tools"
    Resource       = "Managed by Terraform"
    Description    = "CN AWS Backups"
    Team           = "DevOps"
    SourcecodeRepo = "https://github.com/clinician-nexus/shared-services-iac"
  }
}
