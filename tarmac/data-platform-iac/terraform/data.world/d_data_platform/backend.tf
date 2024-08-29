terraform {
  required_version = "1.5.0"
  backend "s3" {
    bucket = "cnxs-data-platform-poc-state-bucket" # change to terraform bucket in aws account
    key    = "poc/agentrunner/terraform.tfstate"   # datadotworld/terraform.tfstate
    region = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
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
