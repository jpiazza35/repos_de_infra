terraform {
  backend "s3" {
    profile        = "p_data_platform"
    bucket         = "terraform-state-us-east-1-417425771013"
    key            = "data-platform-iac/github.tfstate"
    dynamodb_table = "dyndb-terraform-locks-us-east-1"
    region         = "us-east-1"
  }

  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}
