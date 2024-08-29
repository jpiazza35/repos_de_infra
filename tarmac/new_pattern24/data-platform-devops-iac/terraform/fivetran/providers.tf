terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13"
      configuration_aliases = [
        aws,
        aws.ss_network
      ]
    }
  }
}

provider "aws" {
  alias   = "ss_network"
  profile = "ss_network"
  region  = "us-east-1"

  default_tags {
    tags = {
      Environment    = var.env
      App            = var.app
      Resource       = "Managed by Terraform"
      Description    = "${title(var.app)} Related Configuration"
      Team           = "DevOps"
      SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    }
  }
}

provider "aws" {
  alias   = "ss_tools"
  profile = "ss_tools"
  region  = "us-east-1"

  default_tags {
    tags = {
      Environment    = var.env
      App            = var.app
      Resource       = "Managed by Terraform"
      Description    = "${title(var.app)} Related Configuration"
      Team           = "DevOps"
      SourceCodeRepo = "https://github.com/clinician-nexus/data-platform-devops-iac"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
