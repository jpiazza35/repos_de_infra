resource "aws_iam_user" "user_01" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "user.01"

  tags = var.tags
}

resource "aws_iam_user" "user_02" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "user.02"

  tags = var.tags
}

resource "aws_iam_user" "user_03" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "user.03"

  tags = var.tags
}

resource "aws_iam_user" "user_04" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "user.04"

  tags = var.tags
}
