locals {
  default = var.enabled ? 1 : 0

  iam_role_name = var.iam_role_name == "" ? format("%s-github-oidc-custom-role", local.github_repo_name[0]) : var.iam_role_name

  github_organizations = toset(
    [
      for repo in var.github_repositories : split("/", repo)[0]
    ]
  )

  github_repo_name = tolist(
    [
      for repo in var.github_repositories : split("/", repo)[1]
    ]
  )

  oidc_provider_arn = var.enabled ? (
    var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn
  ) : ""

  partition = data.aws_partition.current[0].partition

  issuer     = "token.actions.githubusercontent.com"
  issuer_url = "https://${local.issuer}"

  # The jwks_uri is not guaranteed to be the same domain as the issuer_url
  # according to OIDC and AWS pins to the jwks_uri
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
  jwks_uri = jsondecode(data.http.github_openid_configuration[0].response_body).jwks_uri
}
