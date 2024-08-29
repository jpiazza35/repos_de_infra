terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
    }
    phpipam = {
      source  = "lord-kyron/phpipam"
      version = "~> 1.5.2"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.19.0"
    }
  }
}

provider "null" {}

provider "aws" {}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "use2"
  region = "us-east-2"
}

provider "aws" {
  alias = "log-archive"
  /* region = "us-east-1" */

  assume_role {
    role_arn = "arn:aws:iam::175542716674:role/cn-cross-account-read-role"
  }
}

provider "phpipam" {
  app_id = data.vault_generic_secret.phpipam.data["app_id"]

  endpoint = "https://phpipam.cliniciannexus.com/api"

  password = data.vault_generic_secret.phpipam.data["password"]

  username = data.vault_generic_secret.phpipam.data["username"]

  insecure = false
}

provider "vault" {
  address          = "https://vault.cliniciannexus.com:8200"
  skip_child_token = false
}

