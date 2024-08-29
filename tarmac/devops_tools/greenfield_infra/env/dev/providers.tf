provider "aws" {
  profile = var.profile
  region  = var.region
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "900730278499-dev-terraform-state-sa-east-1"
    dynamodb_table = "900730278499-dev-terraform-locks-sa-east-1"
    encrypt        = "true"
    key            = "greenfield.tfstate"
    profile        = "tarmac"
    region         = "sa-east-1"
  }
}