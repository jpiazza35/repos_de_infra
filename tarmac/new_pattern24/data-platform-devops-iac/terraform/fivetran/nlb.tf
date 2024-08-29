module "nlb" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//lb?ref=1.0.152"

  lb = {
    app                     = var.app
    env                     = var.env
    team                    = "devops"
    load_balancer_type      = "network"
    internal                = true
    create_security_group   = true
    create_static_public_ip = false
    vpc_id                  = ""
    access_logs = {
      bucket  = ""
      prefix  = var.app
      enabled = true
    }
    security_group = {
      ids     = []
      ingress = local.ingress_rules
      egress  = []
    }
    enable_deletion_protection = false
    routes                     = var.routes
    tags = {
      Environment    = var.env
      App            = var.app
      Resource       = "Managed by Terraform"
      Description    = "NLB Related Configuration"
      Team           = "Devops"
      SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    }
  }
}
