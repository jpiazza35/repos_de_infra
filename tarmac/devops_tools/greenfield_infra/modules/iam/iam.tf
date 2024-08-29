resource "aws_iam_user" "automation_user" {
  name = var.automation_user_name
  path = var.automation_user_path
}

resource "aws_iam_user_policy" "automation_user_distribution" {
  name   = "CreateInvalidationCloudFrontDevDistribution"
  user   = aws_iam_user.automation_user.name
  policy = data.aws_iam_policy_document.distribution_invalidation.json
}

resource "aws_iam_user_policy" "automation_user_s3" {
  name   = "PutOnlyFrontendBucket"
  user   = aws_iam_user.automation_user.name
  policy = data.aws_iam_policy_document.bucket_putonly.json
}
