provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Script     = "Terraform"
      Repository = "https://github.com/clinician-nexus/terraform-s3-module"
      Module     = "S3"
    }
  }
}
