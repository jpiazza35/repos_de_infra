# Create trust policy allowing an org "admin" account to assume a role
data "aws_iam_policy_document" "org_admin_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "${data.aws_ssm_parameter.org_admin_account.value}"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

# Create cross account role for admin access
resource "aws_iam_role" "org_mgmt_role" {
  name               = "cn-org-mgmt-role"
  assume_role_policy = data.aws_iam_policy_document.org_admin_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}
