terraform {
  backend "s3" {
    bucket         = "terraform-state-us-east-1-417425771013"
    key            = "{{ KEY }}.tfstate"
    dynamodb_table = "dyndb-terraform-locks-us-east-1"
    region         = "us-east-1"
  }
}
