terraform {
  required_version = "~> 1.5.0"
  backend "s3" {
    bucket         = "cn-terraform-state-s3"
    key            = "fivetran/terraform.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::163032254965:role/terraform-backend-role" ## SS_Tools role
    dynamodb_table = "cn-terraform-state"
  }
}
