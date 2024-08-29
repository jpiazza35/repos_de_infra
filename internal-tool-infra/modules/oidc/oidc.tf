resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url = local.oidc_url

  client_id_list = [
    var.oidc_provider_organization
  ]

  thumbprint_list = var.oidc_provider_thumbprint_list
}