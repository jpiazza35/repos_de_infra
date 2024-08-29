data "aws_iam_role" "cross_account_role" {
  name = "${var.env}-databricks-crossaccount"
}

data "aws_iam_policy_document" "pass_role" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.this.arn]
  }
}


data "aws_iam_policy_document" "assume_role_for_ec2" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}
