resource "vault_jwt_auth_backend" "azure_oidc" {
  count        = local.count
  description  = "Azure Authentication"
  path         = "oidc"
  type         = "oidc"
  default_role = "readers"

  oidc_discovery_url = "https://login.microsoftonline.com/${jsondecode(data.aws_secretsmanager_secret_version.ad[count.index].secret_string)["TENANT_ID"]}/v2.0"

  oidc_client_id = jsondecode(data.aws_secretsmanager_secret_version.ad[count.index].secret_string)["APP_ID"]

  oidc_client_secret = jsondecode(data.aws_secretsmanager_secret_version.ad[count.index].secret_string)["CLIENT_SECRET"]

  tune {
    listing_visibility = "unauth"
    default_lease_ttl  = "768h"
    max_lease_ttl      = "768h"
    token_type         = "default-service"
  }

  lifecycle {
    ignore_changes = [
      default_role
    ]
  }
}

