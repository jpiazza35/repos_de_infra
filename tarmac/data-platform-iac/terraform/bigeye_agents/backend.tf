terraform {
  # prod backend with workspaces {dev, prod}
  backend "s3" {
    profile        = "p_data_platform"
    bucket         = "terraform-state-us-east-1-417425771013"
    key            = "bigeye-agent.tfstate"
    dynamodb_table = "dyndb-terraform-locks-us-east-1"
    region         = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = module.workspace_vars.aws_profile_data_platform
  default_tags {
    tags = {
      Product = "bigeye-agent"
      Owner   = "darkoklincharski@cliniciannexus.com"
    }
  }
}
