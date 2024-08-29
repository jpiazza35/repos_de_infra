## Create SSO Saml Certificate with 3 yr rotation
resource "time_rotating" "saml_certificate" {
  count          = var.gallery ? 0 : 1
  rotation_years = 3
}

resource "azuread_service_principal_token_signing_certificate" "saml_certificate" {
  count                = var.gallery ? 0 : 1
  service_principal_id = azuread_service_principal.user.id
  display_name         = "CN=${format("%s", local.prefix)} SSO Certificate"
  end_date             = time_rotating.saml_certificate[count.index].rotation_rfc3339

}

## Cert to file
resource "local_file" "saml_certificate" {
  count    = var.gallery ? 0 : 1
  filename = "${local.prefix}_saml_cert.pem"
  content  = <<-EOT
-----BEGIN CERTIFICATE-----
${azuread_service_principal_token_signing_certificate.saml_certificate[count.index].value}
-----END CERTIFICATE-----
EOT
}
