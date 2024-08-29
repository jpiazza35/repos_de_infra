terraform {
  backend "s3" {
    bucket = "terraform-state-us-east-1-130145099123"
    key    = "data-platform-datalake/scraper-elt-organization-financial-data.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {}
