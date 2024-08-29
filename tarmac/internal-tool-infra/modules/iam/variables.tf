variable "properties" {
  type = any
}
variable "iam_minimum_password_length" {
  type = string
}
variable "iam_password_require_lowercase_characters" {
  type = bool
}
variable "iam_password_require_uppercase_characters" {
  type = bool
}
variable "iam_password_require_numbers" {
  type = bool
}
variable "iam_password_require_symbols" {
  type = bool
}
variable "iam_max_password_age" {
  type = string
}
variable "iam_allow_users_to_change_password" {
  type = bool
}
variable "iam_password_reuse_prevention" {
  type = string
}
