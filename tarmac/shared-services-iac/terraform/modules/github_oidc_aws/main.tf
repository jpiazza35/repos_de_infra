resource "aws_iam_role" "github" {
  count = local.default

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  description           = "Role assumed by the GitHub OIDC provider."
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  name                  = local.iam_role_name
  path                  = var.iam_role_path
  permissions_boundary  = var.iam_role_permissions_boundary
  tags                  = var.tags

  dynamic "inline_policy" {
    for_each = var.iam_role_inline_policies

    content {
      name   = inline_policy.key
      policy = inline_policy.value
    }
  }
}

resource "aws_iam_role_policy_attachment" "admin" {
  count = var.enabled && var.attach_admin_policy ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.github[count.index].id
}

resource "aws_iam_role_policy_attachment" "read_only" {
  count = var.enabled && var.attach_read_only_policy ? 1 : 0

  policy_arn = "arn:${local.partition}:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.github[count.index].id
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.enabled ? length(var.iam_role_policy_arns) : 0

  policy_arn = var.iam_role_policy_arns[count.index]
  role       = aws_iam_role.github[count.index].id
}

resource "aws_iam_openid_connect_provider" "github" {
  count = var.enabled && var.create_oidc_provider ? 1 : 0

  client_id_list = concat(
    [
      for org in local.github_organizations : "https://github.com/${org}"
    ],
    ["sts.amazonaws.com"]
  )

  tags = var.tags
  thumbprint_list = distinct(
    # Per https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
    concat(
      [
        "6938fd4d98bab03faadb97b34396831e3780aea1",
        "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
      ],
      [
        data.tls_certificate.github[count.index].certificates[0].sha1_fingerprint
      ]
    )
  )
  url = local.issuer_url
}
