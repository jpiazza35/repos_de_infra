locals {
  default = terraform.workspace == "sharedservices" ? 1 : 0

  kms_alias = "alias/${var.app}-${var.env}-kms"
}

data "aws_caller_identity" "current" {
}
