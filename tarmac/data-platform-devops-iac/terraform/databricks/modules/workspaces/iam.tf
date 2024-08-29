resource "aws_iam_role" "cross_account_role" {
  name               = format("%s-crossaccount", local.prefix)
  assume_role_policy = data.databricks_aws_assume_role_policy.assume_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "cross_account_policy" {
  name   = format("%s-policy", local.prefix)
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.cross_acct_policy.json
}


resource "aws_iam_policy" "tag_enforcement" {
  name        = format("%s-tag-enforcement", local.prefix)
  description = "Enforces the required tags on the Databricks resources"
  policy      = data.aws_iam_policy_document.mandatory_tags.json
}

resource "aws_iam_role_policy_attachment" "tag_enforcement" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.tag_enforcement.arn
}