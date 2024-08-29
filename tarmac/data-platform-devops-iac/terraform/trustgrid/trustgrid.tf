module "trustgrid" {
  source = "./modules/trustgrid"

  env                 = var.env
  app                 = var.app
  asg_min             = var.asg_min
  asg_max             = var.asg_max
  asg_desired         = var.asg_desired
  eni                 = var.eni
  vol_size            = var.vol_size
  instance_type       = var.instance_type
  retention_in_days   = var.retention_in_days
  additional_sg_rules = var.additional_sg_rules

  tags = {
    Environment    = var.env
    App            = var.app
    Resource       = "Managed by Terraform"
    Description    = "Data.World Trustgrid"
    Team           = "Data Platform"
    SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
  }

}
