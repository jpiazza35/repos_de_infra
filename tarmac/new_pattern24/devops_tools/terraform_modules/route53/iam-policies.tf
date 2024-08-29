# IAM policy that allows permissions to the IAM role in the Shared Services account that will be assumed by users from ProductOU accounts
resource "aws_iam_policy" "allow_cross_account_access_shared_account" {
  count = var.create_assume_role ? 1 : 0

  name        = "${var.tags["Environment"]}-${var.tags["Product"]}-cross-account-assume-role"
  description = "This policy gives permissions in the Shared Services account."
  path        = "/"
  policy      = data.template_file.allow_cross_account_access_shared_account.rendered

  tags = var.tags
}

# Attach VPC permissions to the core-shared-services-cross-account-assume-role
resource "aws_iam_role_policy_attachment" "shared_cross_account_access_role" {
  count = var.create_assume_role ? 1 : 0

  role       = aws_iam_role.shared_cross_account_assume_role[count.index].name
  policy_arn = aws_iam_policy.allow_cross_account_access_shared_account[count.index].arn
}

resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  count = var.create_assume_role ? 1 : 0

  role       = aws_iam_role.shared_cross_account_assume_role[count.index].name
  policy_arn = data.aws_iam_policy.ecr_read_only_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_full_acess_policy" {
  count = var.create_assume_role ? 1 : 0

  role       = aws_iam_role.shared_cross_account_assume_role[count.index].name
  policy_arn = data.aws_iam_policy.s3_full_acess_policy.arn
}