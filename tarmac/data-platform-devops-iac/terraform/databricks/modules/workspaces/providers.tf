terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      configuration_aliases = [
      ]
    }
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws,
        aws.ss_network
      ]
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

// Initialize the Databricks provider in "normal" (workspace) mode.
provider "databricks" {
  // In workspace mode, you don't have to give providers aliases. Doing it here, however,
  // makes it easier to reference, for example when creating a Databricks personal access token
  // later in this file.
  alias = "created_workspace"
  host  = element(databricks_mws_workspaces.workspace[*].workspace_url, 0)
  # client_id     = databricks_service_principal_secret.admin.id
  # client_secret = databricks_service_principal_secret.admin.secret
  username = var.databricks_username
  password = var.databricks_password
}

provider "databricks" {
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  username   = var.databricks_username
  password   = var.databricks_password
}

provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  username   = var.databricks_username
  password   = var.databricks_password
}

