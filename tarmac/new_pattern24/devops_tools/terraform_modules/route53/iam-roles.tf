# The IAM role that will be assumed by ProductOU accounts users to create the NS records in the main DNS zone in the Shared Services AWS account.
resource "aws_iam_role" "shared_cross_account_assume_role" {
  count = var.create_assume_role ? 1 : 0

  name               = "${var.tags["Environment"]}-${var.tags["Product"]}-cross-account-assume-role"
  assume_role_policy = var.allow_assume_role_productou_accounts
  path               = "/"
  description        = "This IAM role is assumed by users from the other ProductOU accounts and gives cross account permissions."

  tags = var.tags
}