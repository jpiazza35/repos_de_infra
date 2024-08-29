

resource "aws_iam_role" "this" {
  name               = "${local.qualified_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_ec2.json
}


resource "aws_iam_policy" "this_policy" {
  name   = "${local.qualified_name}-policy"
  policy = var.iam_policy_json
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  policy_arn = aws_iam_policy.this_policy.arn
  role       = aws_iam_role.this.name
}


resource "aws_iam_policy" "pass_role" {
  name   = "shared-pass-role-for-${local.qualified_name}"
  policy = data.aws_iam_policy_document.pass_role.json
}

resource "aws_iam_role_policy_attachment" "cross_account" {
  policy_arn = aws_iam_policy.pass_role.arn
  role       = data.aws_iam_role.cross_account_role.name
}

resource "aws_iam_instance_profile" "artifact" {
  name = "${local.qualified_name}-instance-profile"
  role = aws_iam_role.this.name
}

resource "time_sleep" "iam_pass_propagate" {
  # there's always a delay required when dealing with databricks and IAM
  depends_on      = [aws_iam_role_policy_attachment.cross_account]
  create_duration = "15s"
}

resource "databricks_instance_profile" "this" {
  depends_on           = [time_sleep.iam_pass_propagate]
  instance_profile_arn = aws_iam_instance_profile.artifact.arn
}
