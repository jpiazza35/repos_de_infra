data "aws_partition" "current" {
  count = local.default
}

data "aws_iam_policy_document" "assume_role" {
  count = local.default

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test = "StringLike"
      values = [
        for repo in var.github_repositories :
        "repo:%{if length(regexall(":+", repo)) > 0}${repo}%{else}${repo}:*%{endif}"
      ]
      variable = "token.actions.githubusercontent.com:sub"
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    principals {
      identifiers = [
        local.oidc_provider_arn
      ]
      type = "Federated"
    }
  }

  version = "2012-10-17"
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.enabled && !var.create_oidc_provider ? 1 : 0

  url = "https://token.actions.githubusercontent.com"
}

data "tls_certificate" "github" {
  count = local.default
  url   = local.jwks_uri
}

data "http" "github_openid_configuration" {
  count = local.default
  request_headers = {
    Accept = "application/json"
  }
  url = "${local.issuer_url}/.well-known/openid-configuration"
}
