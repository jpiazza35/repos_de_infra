provider "aws" {
  profile = var.profile
  region  = var.region
}

terraform {
  required_version = "1.0.11"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-eu-central-1-724899048942"
    dynamodb_table = "dyndb-terraform-locks-eu-central-1"
    encrypt        = "true"
    key            = "aws-terraform-dashboard-vault.tfstate"
    profile        = "dtcloud-proxy-dev"
    region         = "eu-central-1"
  }
}
