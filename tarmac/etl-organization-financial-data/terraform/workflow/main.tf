# NonProd-Databricks01 AWS Account, nonprod databricks
terraform {
  required_version = "1.4.6"
  backend "s3" {
    bucket = "sc-datalake-remote-state-terraform-backend-us-east-1"
    key    = "nonprod/data-platform-datalake/elt-organization-financial-data.tfstate"
    region = "us-east-1"
  }

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.16.1"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "databricks" {}

provider "aws" {}
