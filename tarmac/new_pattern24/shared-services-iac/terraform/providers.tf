terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.27"
    }
    phpipam = {
      source  = "lord-kyron/phpipam"
      version = "~> 1.5"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.23"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    nexus = {
      source  = "datadrivers/nexus"
      version = "~> 1.22"
    }
  }
}

provider "aws" {
  alias   = "ss_network"
  profile = "ss_network"
}

provider "aws" {
  alias   = "ss_network_use2"
  profile = "ss_network"
  region  = "us-east-2"
}

provider "aws" {
  region = "us-east-1"
}

provider "phpipam" {
  app_id = jsondecode(data.aws_secretsmanager_secret_version.secret[0].secret_string)["app_id"]

  endpoint = "https://phpipam.cliniciannexus.com/api"

  password = jsondecode(data.aws_secretsmanager_secret_version.secret[0].secret_string)["password"]

  username = jsondecode(data.aws_secretsmanager_secret_version.secret[0].secret_string)["username"]

  insecure = false
}

provider "vault" {
  address          = "https://vault.cliniciannexus.com:8200"
  skip_child_token = true
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  experiments {
    manifest_resource = true
  }
}

provider "kubectl" {
  config_path = "~/.kube/config"
}

provider "nexus" {
  insecure = false
  password = jsondecode(data.aws_secretsmanager_secret_version.sonatype_secret_version[0].secret_string)["password"]
  username = jsondecode(data.aws_secretsmanager_secret_version.sonatype_secret_version[0].secret_string)["username"]
  url      = "https://sonatype.cliniciannexus.com"
}

provider "aws" {
  alias   = "d_data_platform"
  profile = "d_data_platform"
}

provider "aws" {
  alias   = "p_data_platform"
  profile = "p_data_platform"
}

provider "aws" {
  alias   = "infra_prod"
  profile = "infra_prod"
}
