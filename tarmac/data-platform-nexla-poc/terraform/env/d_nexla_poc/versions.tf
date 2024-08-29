provider "aws" {
  profile = var.profile
  region  = var.region
}

## D_NEXLA_POC AWS account details:
terraform {
  required_version = "1.3.9"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-us-east-1-395430156876"
    dynamodb_table = "dyndb-terraform-locks-us-east-1"
    encrypt        = "true"
    key            = "bastion-infra.tfstate"
    profile        = "d_nexla_poc"
    region         = "us-east-1"
  }
}
