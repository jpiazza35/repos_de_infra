# Create secret mounts
resource "vault_mount" "kv" {
  for_each = var.env == "shared_services" ? {
    for v in toset(var.paths) : v => v
  } : {}

  path = each.value

  type        = "kv"
  options     = { version = "1" }
  description = "${title(each.value)} secret engine mount"
}

resource "vault_mount" "aws" {
  count = local.create_aws_auth
  path  = "aws/${data.aws_caller_identity.target.account_id}"

  type        = "kv"
  options     = { version = "1" }
  description = "${"aws/${data.aws_caller_identity.target.account_id}"} secret engine mount"
}
