module "phpipam" {
  source            = "./modules/phpipam"
  cidr_ranges       = var.cidr_ranges
  azure_cidr_ranges = var.azure_cidr_ranges
  full_vpcs         = var.full_vpcs
}
