terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }

    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.databricks,
        aws.s3_source
      ]
    }
  }
}

provider "aws" {
  alias   = "databricks"
  profile = "ss_databricks"
}

provider "aws" {
  alias = "s3_source"
  # profile = "nonprod_edw"
}

provider "databricks" {
  profile = "sdlc"
}
