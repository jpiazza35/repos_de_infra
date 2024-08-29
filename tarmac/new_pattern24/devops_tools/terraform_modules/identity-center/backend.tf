provider "aws" {
  profile = var.profile
  region  = var.region
}

terraform {
  required_version = "1.6.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = ""
    dynamodb_table = ""
    encrypt        = "true"
    key            = "aws-iam-identity-center.tfstate"
    profile        = ""
    region         = "us-east-1"
  }
}
