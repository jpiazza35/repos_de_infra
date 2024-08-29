module "sso" {
  source = "../modules/azure_sso_saml"

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
