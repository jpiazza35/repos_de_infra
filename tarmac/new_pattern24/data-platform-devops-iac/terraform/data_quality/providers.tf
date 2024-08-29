provider "aws" {
  region = var.aws_region
}

provider "aws" {
  region  = var.aws_region
  alias   = "ss_network"
  profile = "ss_network"
}