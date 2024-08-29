terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.source,
        aws.target
      ]
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}
