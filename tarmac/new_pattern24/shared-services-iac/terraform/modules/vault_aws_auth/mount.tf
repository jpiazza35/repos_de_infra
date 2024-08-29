resource "vault_mount" "kv" {
  path = "aws/${data.aws_caller_identity.target.account_id}"

  type        = "kv"
  options     = { version = "1" }
  description = "${"aws/${data.aws_caller_identity.target.account_id}"} secret engine mount"
}
