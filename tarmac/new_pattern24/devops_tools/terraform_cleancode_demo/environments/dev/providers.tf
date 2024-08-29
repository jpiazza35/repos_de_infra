terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60.0"
    }
  }
  backend "s3" {
    # BACKEND CONFIGURATION
  }
  required_version = ">= 1.6.0"
}

provider "aws" {
  profile = var.global_args.profile
  region  = var.global_args.region
}
