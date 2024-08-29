## PHPIPAM

module "dns" {
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
    "phpipam"
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
}


## Sonatype Artifactory

module "sonatype_dns" {
  source = "./modules/dns"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env               = var.env
  vpc_id            = data.aws_vpc.vpc[0].id
  lb_dns_name       = module.ecs.sonatype_lb_dns_name
  lb_dns_zone       = module.ecs.sonatype_lb_dns_zone
  dns_name          = "cliniciannexus.com"
  create_local_zone = false
  record_prefix = [
    "sonatype"
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
}

## INCIDENT BOT

module "incident_bot_dns" {
  source = "./modules/dns"
  providers = {
    aws            = aws
    aws.ss_network = aws.ss_network
  }
  env               = var.env
  vpc_id            = data.aws_vpc.vpc[0].id
  lb_dns_name       = module.ecs.incident_bot_lb_dns_name
  lb_dns_zone       = module.ecs.incident_bot_lb_dns_zone
  dns_name          = "cliniciannexus.com"
  create_local_zone = false
  record_prefix = [
    "incident-bot"
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
}
