app = "Workday"
env = "dev"

redirect_uris = []
identifier_uris = [
  "api:test"
]

# Groups to be added to the Enterprise App for login access via SSO
groups = []

## Only modify if you know what you are doing
gallery                       = false
id_token_issuance_enabled     = true
access_token_issuance_enabled = false

sign_in_audience = "AzureADMyOrg"

homepage_url = "https://account.activedirectory.windowsazure.com:444/applications/default.aspx?metadata=customappsso|ISV9.1|primary|z"

