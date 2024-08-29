resource "aws_iam_role" "msk" {
  name               = "databricks_msk_assume_role"
  assume_role_policy = var.env == "stage" ? data.aws_iam_policy_document.assume_role_policy_stage.json : data.aws_iam_policy_document.assume_role_policy.json

  inline_policy {
    name   = "msk_policy"
    policy = data.aws_iam_policy_document.msk.json
  }
}