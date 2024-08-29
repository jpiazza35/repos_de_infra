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

resource "aws_iam_group_membership" "admin" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "AdministratorGroup membership"
  group = aws_iam_group.admin[count.index].name
  users = [
    aws_iam_user.darko_tarmac[count.index].name,
    aws_iam_user.antonio_tarmac[count.index].name,
    aws_iam_user.ezequiel_tarmac[count.index].name,
    aws_iam_user.hector_tarmac[count.index].name,
    aws_iam_user.dominic_ruettimann_dtcloud[count.index].name,
  ]
}

resource "aws_iam_group_membership" "billing" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "BillingGroup membership"
  group = aws_iam_group.billing[count.index].name
  users = [
    aws_iam_user.dominic_ruettimann_dtcloud[count.index].name,
  ]
}

resource "aws_iam_group_membership" "iam_change_password" {
  count = var.is_root_aws_account ? 1 : 0
  name  = "IAMChangePassword group membership"
  group = aws_iam_group.iam_change_password[count.index].name
  users = [
    aws_iam_user.darko_tarmac[count.index].name,
    aws_iam_user.antonio_tarmac[count.index].name,
    aws_iam_user.ezequiel_tarmac[count.index].name,
    aws_iam_user.hector_tarmac[count.index].name,
    aws_iam_user.dominic_ruettimann_dtcloud[count.index].name,
  ]
}