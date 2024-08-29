terraform {
  required_version = "~>1.7.1"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-us-east-1-417425771013" # change to terraform bucket in aws account
    key            = "datadotworld/terraform.tfstate"         # datadotworld/terraform.tfstate
    region         = "us-east-1"
    profile        = "p_data_platform"
    dynamodb_table = "dyndb-terraform-locks-us-east-1"
  }
}
# Configure the AWS Provider
provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Product = "data.world"
      Owner   = "Data Platform"
    }
  }
}

# Configure the Hashicorp Vault
provider "vault" {
  address          = "https://vault.cliniciannexus.com:8200"
  skip_child_token = true
}
