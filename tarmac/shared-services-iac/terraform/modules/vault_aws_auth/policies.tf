resource "vault_policy" "aws" {
  count = local.create_aws_auth
  name  = format("%s-kv-rw", data.aws_caller_identity.target.account_id)

  policy = templatefile("${path.module}/policies/aws.hcl", {
    ACCOUNT_ID = data.aws_caller_identity.target.account_id
    }
  )
}
