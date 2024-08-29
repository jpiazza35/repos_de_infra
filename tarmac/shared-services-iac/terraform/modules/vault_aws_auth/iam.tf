resource "aws_iam_policy" "aws_auth" {
  provider = aws.target
  count    = local.create_aws_auth
  name     = "vault_aws_auth"
  path     = "/"
  policy   = data.aws_iam_policy_document.aws_auth[count.index].json
}

resource "aws_iam_role" "aws_auth" {
  provider = aws.target
  count    = local.create_aws_auth
  name     = "vault_aws_auth"
  path     = "/"
  managed_policy_arns = [
    aws_iam_policy.aws_auth[count.index].arn,
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  assume_role_policy = data.aws_iam_policy_document.assume_role[count.index].json

}

resource "aws_iam_instance_profile" "aws_auth" {
  provider = aws.target
  count    = var.create_aws_auth && var.iam_instance_profile_arn == null ? local.create_aws_auth : 0
  name     = "vault_aws_auth"
  role     = aws_iam_role.aws_auth[count.index].name
}


resource "aws_iam_policy" "aws_auth_source" {
  provider = aws.source
  count    = local.create_aws_auth
  name     = format("vault_aws_auth_%s", data.aws_caller_identity.target.account_id)
  path     = "/"
  policy   = data.aws_iam_policy_document.aws_auth[count.index].json
}

resource "aws_iam_role" "aws_auth_source" {
  provider = aws.source
  count    = local.create_aws_auth

  name = format("vault_aws_auth_%s", data.aws_caller_identity.target.account_id)

  path = "/"

  managed_policy_arns = [
    aws_iam_policy.aws_auth_source[count.index].arn,
  ]

  assume_role_policy = data.aws_iam_policy_document.assume_role_source[count.index].json

}
