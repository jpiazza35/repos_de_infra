terraform {
  required_version = "= 1.4.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"

    }
  }
}