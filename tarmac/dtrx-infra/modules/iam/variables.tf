variable "tags" {
  type = map(string)
}

variable "region" {
  type = string
}

variable "sso_instance" {
}

variable "logging_aws_account_id" {
}

variable "shared_services_aws_account_id" {
}

variable "product_ou_arn" {
}

variable "is_root_aws_account" {
  description = "Whether the IAM resources are in Root AWS account or other."
}

variable "iam_minimum_password_length" {
  description = "The minimum IAM password length."
}

variable "iam_password_require_lowercase_characters" {
  description = "Whether to require lowercase characters in IAM passwords."
}

variable "iam_password_require_numbers" {
  description = "Whether to require numbers in IAM passwords."
}

variable "iam_password_require_uppercase_characters" {
  description = "Whether to require uppercase characters in IAM passwords."
}

variable "iam_password_require_symbols" {
  description = "Whether to require symbols in IAM passwords."
}

variable "iam_allow_users_to_change_password" {
  description = "Whether to allow users to change their IAM password."
}

variable "iam_password_reuse_prevention" {
  description = "The number of previous passwords that users are prevented from reusing."
}

variable "iam_max_password_age" {
  description = "The number of days until users are required to change their IAM password."
}
