module "organizations" {
  source = "./modules/organizations"

  dev_accounts_org_unit = var.dev_accounts_org_unit
  region                = var.region
}