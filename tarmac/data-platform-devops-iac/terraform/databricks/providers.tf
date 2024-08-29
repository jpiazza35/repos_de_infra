terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.27"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12"
    }
    phpipam = {
      source  = "lord-kyron/phpipam"
      version = "~> 1.5.2"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.41.0"
    }

    vault = {
      source = "hashicorp/vault"
    }
  }
}

provider "phpipam" {
  app_id = jsondecode(data.aws_secretsmanager_secret_version.secret[0].secret_string)["app_id"]

  endpoint = "https://phpipam.cliniciannexus.com/api"

  password = jsondecode(data.aws_secretsmanager_secret_version.secret[0].secret_string)["password"]

  username = jsondecode(data.aws_secretsmanager_secret_version.secret[0].secret_string)["username"]

  insecure = false
}

provider "databricks" {
  host       = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["host"]
  account_id = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["account_id"]
  username   = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["username"]
  password   = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["password"]
}

provider "databricks" {
  alias      = "mws"
  host       = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["host"]
  account_id = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["account_id"]
  username   = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["username"]
  password   = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["password"]
}

provider "aws" {
  alias   = "sstools"
  profile = "ss_tools" #SSTools
}

provider "aws" {
  alias   = "ss_network"
  profile = "ss_network" #ss_network
}

provider "aws" {} #CN SDLC Databricks AWS Account

provider "aws" {
  alias   = "d_data_platform"
  profile = "d_data_platform"
}

provider "aws" {
  alias   = "p_data_platform"
  profile = "p_data_platform"
}

provider "vault" {
  address          = "https://vault.cliniciannexus.com:8200"
  skip_child_token = true
}
