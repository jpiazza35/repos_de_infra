terraform {
  # prod backend with workspaces {dev, prod}
  backend "s3" {
    bucket         = "cn-databricks-terraform-state-s3"
    key            = "data-platform-iac/databricks-initial-release.tfstate"
    dynamodb_table = "cn-databricks-terraform-state"
    region         = "us-east-1"
    assume_role = {
      role_arn = "arn:aws:iam::163032254965:role/databrics_tf_backend_role"
    }
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

    fivetran = {
      version = "~> 1.1"
      source  = "fivetran/fivetran"
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
