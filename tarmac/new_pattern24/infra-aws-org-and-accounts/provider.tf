provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Script      = "Terraform"
      Repository  = "https://github.com/clinician-nexus/infra-aws-org-and-accounts"
    }
  }
}
