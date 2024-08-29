# Create a Service Principal for the App Registration. 
resource "azuread_service_principal" "user" {
  application_id = azuread_application.main.application_id

  app_role_assignment_required = true

  feature_tags {
    enterprise            = var.enterprise
    gallery               = var.gallery
    custom_single_sign_on = var.custom_single_sign_on
  }

  preferred_single_sign_on_mode = var.preferred_single_sign_on_mode

  notification_email_addresses = var.notification_email_addresses

  use_existing = var.gallery ? true : false

  ## Work around to avoid errors when creating the application with an identifier URI that does not exist in our domain (sullivancotter.com) Update is successful, but create returns an error
  ## https://github.com/hashicorp/terraform-provider-azuread/issues/635
  ## https://learn.microsoft.com/en-us/azure/active-directory/develop/reference-breaking-changes#appid-uri-in-single-tenant-applications-will-require-use-of-default-scheme-or-verified-domains
  provisioner "local-exec" {
    command = <<-SHELL
      sleep 30 && \
      az ad app update \
        --id ${azuread_application.main.object_id} \
        --identifier-uris ${local.identifier_uris}
    SHELL
  }
}
