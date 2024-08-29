terraform {
  backend "s3" {
    bucket         = "cn-databricks-terraform-state-s3"
    key            = "databricks-common/batch-deidentification.tfstate"
    dynamodb_table = "cn-databricks-terraform-state"
    region         = "us-east-1"
    assume_role = {
      role_arn = "arn:aws:iam::163032254965:role/databrics_tf_backend_role"
    }
  }

  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}

provider "databricks" {
  profile = module.workspace_vars.databricks_profile
}
