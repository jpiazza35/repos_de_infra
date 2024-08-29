module "ecr" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//ecr"

  app  = var.app
  env  = var.env
  tags = var.tags
}
