resource "vault_auth_backend" "aws" {
  count = local.create_aws_auth
  type  = "aws"
  path  = data.aws_caller_identity.target.account_id
}

resource "vault_aws_auth_backend_role" "aws" {
  count   = local.create_aws_auth
  backend = vault_auth_backend.aws[count.index].path
  role    = format("%s-vault-aws-auth-role", data.aws_caller_identity.target.account_id)

  auth_type = "iam"

  bound_account_ids = [
    data.aws_caller_identity.target.account_id
  ]

  bound_vpc_ids = var.vpc_ids == null ? [
    data.aws_vpc.vpc[count.index].id
  ] : var.vpc_ids

  bound_iam_instance_profile_arns = var.iam_instance_profile_arn != null ? concat(var.iam_instance_profile_arn, [
    aws_iam_instance_profile.aws_auth[count.index].arn
    ]) : [
    aws_iam_instance_profile.aws_auth[count.index].arn
  ]

  bound_iam_principal_arns = [
    aws_iam_role.aws_auth[count.index].arn,
    "arn:aws:iam::${data.aws_caller_identity.target.account_id}:role/*"
  ]

  inferred_entity_type = "ec2_instance"

  inferred_aws_region = data.aws_region.current.name

  resolve_aws_unique_ids = true

  token_ttl     = 120
  token_max_ttl = 240
  token_policies = [
    "default",
    vault_policy.aws[count.index].name
  ]
}

resource "vault_aws_auth_backend_sts_role" "role" {
  count      = local.create_aws_auth
  backend    = vault_auth_backend.aws[count.index].path
  account_id = data.aws_caller_identity.target.account_id
  sts_role   = aws_iam_role.aws_auth[count.index].arn

}

resource "vault_aws_auth_backend_client" "aws_auth" {
  count                      = local.create_aws_auth
  backend                    = vault_auth_backend.aws[count.index].path
  iam_server_id_header_value = "vault.cliniciannexus.com"
  sts_region                 = data.aws_region.current.name
  sts_endpoint               = "https://sts.${data.aws_region.current.name}.amazonaws.com"
}
