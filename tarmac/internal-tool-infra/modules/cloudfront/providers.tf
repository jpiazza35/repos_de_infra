provider "aws" {
  alias  = "dev_account"
  region = var.region
  assume_role {
    role_arn = var.aws_acc_id_arn
  }
}
