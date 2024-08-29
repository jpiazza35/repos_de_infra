terraform {
  backend "s3" {
    bucket         = "cn-shared-services-tf-backend-bucket"
    dynamodb_table = "cn-shared-services-tf-dynamodb-table"
    encrypt        = true
    key            = "github-runner/terraform.tfstate"
    region         = "us-east-1"
  }
}
