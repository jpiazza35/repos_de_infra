terraform {
  backend "s3" {
    bucket         = "cn-aws-networking-tf-backend"
    dynamodb_table = "cn-aws-networking-tf-dynamodb-table"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}
