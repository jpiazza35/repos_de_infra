### Azure AD SSO SAML Application
The terraform configuration in this module can be used to create a custom or Gallery Azure Enterprise Application.

To create an Enterprise App, you must have Azure Directory and Application Write Permissions.

An example usage of this module to create a custom enterprise app:
```
module sso {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//azure_sso_saml"

  redirect_uris = [
    "https://db-redirect-here.dev.cliniciannexus.com/saml/consume"
  ]

  homepage_url = "https://account.activedirectory.windowsazure.com:444/applications/default.aspx?metadata=customappsso|ISV9.1|primary|z"

  id_token_issuance_enabled = true
  access_token_issuance_enabled = false
  
  app = "sample"
  env = "dev"

  gallery = false
  sign_in_audience = "AzureADMyOrg"

  identifier_uris = [
    "https://sample-redirect-here.dev.cliniciannexus.com/saml/path"
  ]

  groups = [
    "developers"
    "devops_team"
  ]

}
```


To create a gallery Application, you need pass the `app` variable - this value should be the display name of the gallery application but can enter other values for a complete solution.

An example usage of this module to create a gallery enterprise app:
```
module sso {
  source = "git::https://github.com/clinician-nexus/shared-services-iac//terraform//modules//azure_sso_saml"
  
  app = "Workday"
  env = "dev"

  gallery = true

  identifier_uris = [
    "https://sample-redirect-here.dev.cliniciannexus.com/saml/path"
  ]

  groups = [
    "developers"
    "devops_team"
  ]

}
```
