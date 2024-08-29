terraform {

  backend "s3" {
    bucket = "cn-terraform-state-s3"
    key    = "mpt-ui.tfstate"
    region = "us-east-1"
    assume_role = {
      role_arn = "arn:aws:iam::163032254965:role/terraform-backend-role" ## SS_Tools role
    }
    dynamodb_table = "cn-terraform-state"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  region  = var.aws_region
  alias   = "ss_tools"
  profile = "ss_tools"
}

provider "aws" {
  region  = var.aws_region
  alias   = "ss_network"
  profile = "ss_network"
}

provider "vault" {
  address          = var.vault_url
  skip_child_token = true
}