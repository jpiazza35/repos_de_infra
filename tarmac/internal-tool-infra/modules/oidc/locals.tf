locals {

  #  "https://oidc.circleci.com/org/441631a8-4be4-4b51-bb18-8dccf4663c25"
  oidc_url = format("%s/%s",
    var.oidc_provider_url,
    var.oidc_provider_organization
  )

  #  "oidc.circleci.com/org/441631a8-4be4-4b51-bb18-8dccf4663c25"
  condition_oidc_url = format("%s/%s",
    substr(var.oidc_provider_url, 8, length(var.oidc_provider_url)),
    var.oidc_provider_organization
  )

  #  CircleCI-Deploy-Role-DEV
  provider_role_fullname = format("%s-Deploy-Role-%s", title(var.oidc_provider_name), upper(var.oidc_environment))

  oidc_provider_tags = merge({
    Name = local.provider_role_fullname
  }, var.oidc_provider_extra_tags)
}