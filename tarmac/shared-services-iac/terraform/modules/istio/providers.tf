terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws,
        aws.ss_network
      ]
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias   = "ss_network"
  profile = "ss_network"
}
