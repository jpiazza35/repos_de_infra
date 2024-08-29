terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }
  backend "s3" {
    bucket         = "default-terraform-state-dev"
    key            = "terraform.tfstate"
    profile        = "default"
    region         = "us-east-1"
    dynamodb_table = "default-terraform-lock-dev"
    encrypt        = true
  }
  required_version = ">= 1.1.5"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}
