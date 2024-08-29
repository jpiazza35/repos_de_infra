terraform {

  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    vault = {
      source = "hashicorp/vault"
    }
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws,
        aws.ss_network,
        aws.infra_prod
      ]
    }
  }
}