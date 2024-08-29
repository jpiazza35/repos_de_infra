terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
      configuration_aliases = [
        aws,
        aws.ss_network
      ]
    }
  }
}

provider "aws" {}

