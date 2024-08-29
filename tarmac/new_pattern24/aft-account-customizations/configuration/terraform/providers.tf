terraform {
  required_providers {
    phpipam = {
      source  = "lord-kyron/phpipam"
      version = "~> 1.5.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
      configuration_aliases = [
        aws.aft-management
      ]
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "ss_databricks" #"aft-target"
  alias   = "use1"

  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}
provider "aws" {
  region  = local.region
  profile = "ss_databricks" #"aft-target"

  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "aft" #"aft-management"
  alias   = "aft-management"
}

provider "aws" {
  region  = "us-east-1"
  profile = "management" #"ct-management"
  alias   = "ct-management"
}

provider "aws" {
  region  = local.region
  profile = "ct-audit"
  alias   = "ct-audit"
}

provider "aws" {
  region  = local.region
  profile = "ct-log-archive"
  alias   = "ct-log-archive"
}

provider "phpipam" {
  app_id = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["app_id"]

  endpoint = "https://phpipam.cliniciannexus.com/api"

  password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["password"]

  username = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["username"]

  insecure = false
}
