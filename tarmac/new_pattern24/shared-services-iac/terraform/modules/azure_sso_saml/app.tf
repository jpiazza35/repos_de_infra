# Generate random UUID for the App Roles.
resource "random_uuid" "app_roles" {
  count = var.gallery ? 0 : length(var.azure_app_roles)
}

resource "random_uuid" "oauth2_scopes" {}

# Create the Azure Application
resource "azuread_application" "main" {
  display_name = var.gallery ? data.azuread_application_template.app[0].display_name : format("SSO for %s", title(local.prefix))

  sign_in_audience        = var.sign_in_audience
  prevent_duplicate_names = var.prevent_duplicate_names

  template_id = var.gallery ? data.azuread_application_template.app[0].template_id : null

  feature_tags {
    custom_single_sign_on = var.custom_single_sign_on
    enterprise            = var.enterprise
    gallery               = var.gallery
  }

  identifier_uris = []

  dynamic "api" {
    for_each = !var.gallery ? ["1"] : []
    content {
      oauth2_permission_scope {
        admin_consent_description = "Allow the application to the app on behalf of the signed-in user."

        admin_consent_display_name = format("Access SSO for %s", title(local.prefix))

        enabled = true

        id   = random_uuid.oauth2_scopes.result
        type = "Admin"

        value = var.gallery ? null : format("https://%s/saml/consume/user_impersonation", var.identifier_uris[0])

        user_consent_description = "Allow the application to the app on behalf of the signed-in user."

        user_consent_display_name = format("Access SSO for %s", title(local.prefix))
      }
    }
  }

  ## Add App Roles
  dynamic "app_role" {
    for_each = !var.gallery ? {
      for index, role in var.azure_app_roles : index => role
    } : {}
    content {
      allowed_member_types = [
        "User",
      ]
      description  = app_role.value.description
      display_name = app_role.value.display_name
      enabled      = true
      id           = random_uuid.app_roles[app_role.key].result
      value        = app_role.value.value
    }
  }

  # Set the redirect URI's, if any.
  web {
    homepage_url = var.gallery ? data.azuread_application_template.app[0].homepage_url : var.homepage_url

    redirect_uris = var.gallery ? [
      data.azuread_application_template.app[0].homepage_url
    ] : var.redirect_uris

    dynamic "implicit_grant" {
      for_each = !var.gallery ? ["1"] : []
      content {
        access_token_issuance_enabled = var.access_token_issuance_enabled
        id_token_issuance_enabled     = var.id_token_issuance_enabled
      }
    }
  }

}
