module "sso" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//azure_sso_saml?ref=v1.0.0"

  redirect_uris = [
    "https://db-redirect-here.dev.cliniciannexus.com/saml/consume"
  ]

  homepage_url = "https://account.activedirectory.windowsazure.com:444/applications/default.aspx?metadata=customappsso|ISV9.1|primary|z"

  id_token_issuance_enabled     = true
  access_token_issuance_enabled = false

  app = "sample"
  env = "dev"

  gallery          = false
  sign_in_audience = "AzureADMyOrg"

  identifier_uris = [
    "https://sample-redirect-here.dev.cliniciannexus.com/saml/path"
  ]

  groups = [
    "developers",
    "devops_team"
  ]

}

### Gallery App
module "sso" {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//azure_sso_saml?ref=v1.0.0"

  app = "Workday"
  env = "dev"

  gallery = true

  identifier_uris = [
    "https://sample-redirect-here.dev.cliniciannexus.com/saml/path"
  ]

  groups = [
    "developers",
    "devops_team"
  ]

}
