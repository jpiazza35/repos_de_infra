terraform {
  # prod backend with workspaces {dev, prod}
  backend "s3" {
    profile        = "p_data_platform"
    bucket         = "terraform-state-us-east-1-417425771013"
    key            = "data-platform-iac/databricks-initial-release.tfstate"
    dynamodb_table = "dyndb-terraform-locks-us-east-1"
    region         = "us-east-1"
  }

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.27.0"
    }

    aws = {
      source = "hashicorp/aws"
    }

    vault = {
      source = "hashicorp/vault"
    }
  }
}

provider "vault" {
  skip_child_token = true
}

provider "aws" {
  region  = var.region
  profile = module.workspace_vars.aws_profile_databricks

  default_tags {
    tags = local.tags
  }
}


provider "databricks" {
  profile = module.workspace_vars.databricks_profile
}
