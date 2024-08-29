provider "aws" {
  alias  = "shared-services"
  region = var.region
  assume_role {
    role_arn = var.shared_services_account_cross_account_assume_role_arn
  }
}