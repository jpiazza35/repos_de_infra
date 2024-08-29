# Generate random UUID for the App Roles.
resource "random_uuid" "app_roles" {
  count = length(var.azure_app_roles)
}

resource "random_uuid" "oauth2_scopes" {}

# Create the Azure Application
resource "azuread_application" "main" {
  provider         = azuread
  display_name     = format("Databricks Workspace SSO for cn-%s", local.prefix)
  sign_in_audience = "AzureADMyOrg"

  feature_tags {
    custom_single_sign_on = true
    enterprise            = true
    gallery               = false
  }

  identifier_uris = []

  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access example on behalf of the signed-in user."
      admin_consent_display_name = format("Access Databricks Workspace SSO for %s", title(local.prefix))
      enabled                    = true
      id                         = random_uuid.oauth2_scopes.result
      type                       = "Admin"
      value                      = format("https://cn-%s.cloud.databricks.com/saml/consume/user_impersonation", local.prefix)

      user_consent_description = "Allow the application to access example on behalf of the signed-in user."

      user_consent_display_name = format("Access Databricks Workspace SSO for %s", title(local.prefix))
    }
  }

  ## Add App Roles
  dynamic "app_role" {
    for_each = {
      for index, role in var.azure_app_roles : index => role
    }
    content {
      allowed_member_types = [
        "User",
      ]
      description  = app_role.value.description
      display_name = app_role.value.display_name
      enabled      = true
      id           = app_role.value.display_name == "User" ? random_uuid.app_roles[0].result : random_uuid.app_roles[1].result
      value        = app_role.value.value
    }
  }

  # Set the redirect URI's, if any.
  web {
    homepage_url = "https://account.activedirectory.windowsazure.com:444/applications/default.aspx?metadata=customappsso|ISV9.1|primary|z"

    redirect_uris = [
      format("https://cn-%s.cloud.databricks.com/saml/consume", local.prefix),
      /* format("https://cn-%s-nexla.cn-%s.cloud.databricks.com/saml/consume", local.prefix), */
      /* format("https://cn-%s.cn-%s.cloud.databricks.com/saml/consume", local.prefix) */
    ]

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = true
    }
  }

  lifecycle {
    ignore_changes = [
      identifier_uris
    ]
  }

}

# Create a Service Principal for the App Registration
resource "azuread_service_principal" "user" {
  application_id               = azuread_application.main.application_id
  app_role_assignment_required = true

  feature_tags {
    enterprise            = true
    gallery               = false
    custom_single_sign_on = true
  }

  preferred_single_sign_on_mode = "saml"

  notification_email_addresses = [
    "devops@cliniciannexus.com",
    "it@cliniciannexus.com"
  ]

  ## Work around to avoid errors when creating the application with an idntifier URI that does not exist in our domain (sullivancotter.com) Update is successful, but create returns an error
  ## https://github.com/hashicorp/terraform-provider-azuread/issues/635
  ## https://learn.microsoft.com/en-us/azure/active-directory/develop/reference-breaking-changes#appid-uri-in-single-tenant-applications-will-require-use-of-default-scheme-or-verified-domains
  provisioner "local-exec" {
    command = <<-SHELL
      sleep 30 && \
      az ad app update \
        --id ${azuread_application.main.object_id} \
        --identifier-uris ${format("https://cn-%s.cloud.databricks.com/saml/consume", local.prefix)}
    SHELL
  }
}

# Assigns the groups to the Enterprise Application, if any.
resource "azuread_app_role_assignment" "group_assignment" {
  for_each            = data.azuread_group.assignment
  app_role_id         = random_uuid.app_roles[0].result
  principal_object_id = each.value.id
  resource_object_id  = azuread_service_principal.user.object_id

}

## Create SSO Saml Certificate with 3 yr rotation
resource "time_rotating" "saml_certificate" {
  rotation_years = 3
}

resource "azuread_service_principal_token_signing_certificate" "saml_certificate" {
  service_principal_id = azuread_service_principal.user.id
  display_name         = "CN=${format("cn-%s", local.prefix)} SSO Certificate"
  end_date             = time_rotating.saml_certificate.rotation_rfc3339

}

## Cert to file
resource "local_file" "saml_certificate" {
  filename = "${local.prefix}_saml_cert.pem"
  content  = <<-EOT
-----BEGIN CERTIFICATE-----
${azuread_service_principal_token_signing_certificate.saml_certificate.value}
-----END CERTIFICATE-----
EOT
}
