provider "aws" {
  alias   = "requester"
  profile = var.profile
  region  = var.region
}

provider "aws" {
  alias  = "accepter"
  region = var.region
  assume_role {
    role_arn = var.logging_account_vpc_assume_role_arn
  }
}

provider "aws" {
  alias  = "product_accepter"
  region = var.region
  assume_role {
    role_arn = var.product_account_vpc_assume_role_arn
  }
}