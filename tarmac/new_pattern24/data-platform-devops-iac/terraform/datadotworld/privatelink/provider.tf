terraform {
  required_version = "~>1.7.1"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "cn-terraform-state-s3"
    key    = "ddw/terraform.tfstate"
    region = "us-east-1"
    assume_role = {
      role_arn = "arn:aws:iam::163032254965:role/terraform-backend-role" ## SS_Tools role
    }
    dynamodb_table = "cn-terraform-state"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}
