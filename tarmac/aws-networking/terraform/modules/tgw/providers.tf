terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws,
        aws.use1,
        aws.use2,
      ]
    }
  }
}
