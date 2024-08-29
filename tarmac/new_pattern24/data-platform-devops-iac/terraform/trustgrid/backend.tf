terraform {
  backend "s3" {
    bucket         = "cn-databricks-terraform-state-s3"
    dynamodb_table = "cn-databricks-terraform-state"
    encrypt        = true
    key            = "trustgrid/terraform.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::163032254965:role/databrics_tf_backend_role"
  }
}
