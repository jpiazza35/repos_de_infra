resource "aws_iam_group" "admin" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "AdministratorGroup"
}

resource "aws_iam_group" "billing" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "BillingGroup"
}

resource "aws_iam_group" "readonly" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "ReadOnlyGroup"
}

resource "aws_iam_group" "iam_change_password" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "IAMChangePasswordGroup"
}

resource "aws_iam_group" "example_machine" {
  count = var.create_example_machine_user ? 1 : 0
  name  = "DocVaultMachineUserGroup"
}

resource "aws_iam_group" "aws_artifact" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "AWSArtifactAccessGroup"
}

resource "aws_iam_group_membership" "admin" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "AdministratorGroup membership"
  group = aws_iam_group.admin[count.index].name
  users = [
    aws_iam_user.user_01[count.index].name,
    aws_iam_user.user_02[count.index].name,
    aws_iam_user.user_03[count.index].name,
    aws_iam_user.user_04[count.index].name,
  ]
}

resource "aws_iam_group_membership" "billing" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "BillingGroup membership"
  group = aws_iam_group.billing[count.index].name
  users = [
    aws_iam_user.user_03-account[count.index].name,
  ]
}

resource "aws_iam_group_membership" "iam_change_password" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "IAMChangePassword group membership"
  group = aws_iam_group.iam_change_password[count.index].name
  users = [
    aws_iam_user.user_01[count.index].name,
    aws_iam_user.user_02[count.index].name,
    aws_iam_user.user_03[count.index].name,
    aws_iam_user.user_04[count.index].name,
  ]
}

resource "aws_iam_group_membership" "example_machine" {
  count = var.create_example_machine_user ? 1 : 0
  name  = "DocVaultMachineUserGroup membership"
  group = aws_iam_group.example_machine[count.index].name
  users = [
    aws_iam_user.doc_vault[count.index].name
  ]
}

resource "aws_iam_group_membership" "aws_artifact" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "AWSArtifactAccessGroup membership"
  group = aws_iam_group.aws_artifact[count.index].name
  users = [
    aws_iam_user.user_03-account[count.index].name
  ]
}