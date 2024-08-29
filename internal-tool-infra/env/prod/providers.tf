terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "tarmac-internal-tool-terraform-state-prod"
    key            = "terraform.tfstate"
    profile        = "internaltool-prod"
    region         = "us-east-1"
    dynamodb_table = "tarmac-internal-tool-default-terraform-lock-prod"
    encrypt        = true
  }
  required_version = ">= 1.1.5"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}
