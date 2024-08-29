terraform {

  backend "s3" {
    bucket         = "cn-terraform-state-s3"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::163032254965:role/terraform-backend-role" ## SS_Tools role
    dynamodb_table = "cn-terraform-state"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}


provider "aws" {
  region = var.aws_region
}

provider "aws" {
  region  = var.aws_region
  alias   = "ss_network"
  profile = "ss_network"
}

provider "vault" {
  address          = var.vault_url
  skip_child_token = true
}

provider "kubernetes" {
  host                   = module.eks_mgmt.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_mgmt.certificate-authority)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", "${local.cluster_name}"]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks_mgmt.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_mgmt.certificate-authority)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", "${local.cluster_name}"]
    }
  }
}

provider "kubectl" {
  host                   = module.eks_mgmt.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_mgmt.certificate-authority)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", "${local.cluster_name}"]
  }
}

