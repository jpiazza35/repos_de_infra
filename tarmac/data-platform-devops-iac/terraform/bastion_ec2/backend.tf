terraform {
  backend "s3" {
    bucket         = "terraform-state-us-east-1-130145099123"
    dynamodb_table = "dyndb-terraform-locks-us-east-1"
    encrypt        = true
    key            = "bastion_ec2/terraform.tfstate"
    region         = "us-east-1"
  }
}