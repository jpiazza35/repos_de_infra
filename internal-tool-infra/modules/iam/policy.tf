resource "aws_iam_account_password_policy" "policy" {
  minimum_password_length        = var.iam_minimum_password_length
  require_lowercase_characters   = var.iam_password_require_lowercase_characters
  require_uppercase_characters   = var.iam_password_require_uppercase_characters
  require_numbers                = var.iam_password_require_numbers
  require_symbols                = var.iam_password_require_symbols
  max_password_age               = var.iam_max_password_age
  allow_users_to_change_password = var.iam_allow_users_to_change_password
  password_reuse_prevention      = var.iam_password_reuse_prevention
}
