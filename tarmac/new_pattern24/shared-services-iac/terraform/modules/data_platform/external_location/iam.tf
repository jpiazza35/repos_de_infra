resource "aws_iam_policy" "external_data_access" {
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${data.aws_s3_bucket.external.id}-access"
    Statement = [
      {
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          data.aws_s3_bucket.external.arn,
          "${data.aws_s3_bucket.external.arn}/*"
        ],
        "Effect" : "Allow"
      }
    ]
  })
  tags = merge(
    var.tags,
    {
      Name = "${var.databricks_workspace_name}-${var.prefix}-external-storage-policy"
  })
}

resource "aws_iam_role" "external_data_access" {
  name               = "${var.databricks_workspace_name}-${var.prefix}-external-access-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = [
    aws_iam_policy.external_data_access.arn
  ]
  tags = merge(
    var.tags,
    {
      Name = "${var.databricks_workspace_name}-${var.prefix}-external-access-role"
  })
}

resource "aws_iam_role_policy" "self_assume" {
  name   = "${var.databricks_workspace_name}-${var.prefix}-external-role-policy"
  role   = aws_iam_role.external_data_access.id
  policy = data.aws_iam_policy_document.role_policy.json
}

resource "aws_iam_role" "cross_account_role" {
  name               = format("%s-databricks-crossaccount-role", var.prefix)
  assume_role_policy = data.databricks_aws_assume_role_policy.assume_policy.json
}

resource "aws_iam_role_policy" "cross_account_policy" {

  name   = format("%s-databricks-crossacount-policy", var.prefix)
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.cross_acct_policy.json
}
