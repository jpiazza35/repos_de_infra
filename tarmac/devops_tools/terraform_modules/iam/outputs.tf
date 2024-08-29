output "iam_password_policy_min_password_length" {
  description = "The minimum password length as set in the account IAM password policy."
  value       = aws_iam_account_password_policy.policy.minimum_password_length
}

output "iam_password_policy_require_lowercase" {
  description = "Whether lowercase characters are required in the account IAM password policy."
  value       = aws_iam_account_password_policy.policy.require_lowercase_characters
}

output "iam_password_policy_require_uppercase" {
  description = "Whether uppercase characters are required in the account IAM password policy."
  value       = aws_iam_account_password_policy.policy.require_uppercase_characters
}

output "iam_password_policy_require_numbers" {
  description = "Whether numbers are required in the account IAM password policy."
  value       = aws_iam_account_password_policy.policy.require_numbers
}

output "iam_password_policy_require_symbols" {
  description = "Whether symbols are required in the account IAM password policy."
  value       = aws_iam_account_password_policy.policy.require_symbols
}

output "iam_password_policy_allow_users_to_change_password" {
  description = "Whether users are allowed to change own password per the account IAM password policy."
  value       = aws_iam_account_password_policy.policy.allow_users_to_change_password
}

output "iam_password_policy_password_reuse_prevention" {
  description = "Number of last passwords that cannot be used per the account IAM password policy."
  value       = aws_iam_account_password_policy.policy.password_reuse_prevention
}

output "iam_password_policy_max_password_age" {
  description = "Number of days after which the passwords expire per the account IAM password policy."
  value       = aws_iam_account_password_policy.policy.max_password_age
}

output "example_machine_iam_user" {
  description = "The name of the Document Vault machine IAM user."
  value       = element(concat(aws_iam_user.doc_vault.*.name, tolist([""])), 0)
}