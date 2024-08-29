module "backup" {
  source            = "./modules/backups"
  region            = var.region
  app               = var.app
  env               = var.env
  enabled           = true
  vault_kms_key_arn = module.kms.kms_key_arn

  tags = {
    Environment = var.env
    App         = var.app
    Resource    = "Managed by Terraform"
    Description = "CN AWS Backups"
  }
}
