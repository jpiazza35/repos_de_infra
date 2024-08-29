aws_acct_name = "SS_DATABRICKS"
region        = "us-east-1"
env           = "sdlc"
app           = "databricks"
groups = {
  admins = [
    "db_sdlc_admin",
    "db_all_workspaces_admins"
  ]
  users = [
    "db_sdlc_engineer",
    "db_sdlc_sandbox",
    "db_sdlc_user",
    "db_sdlc_mpt_developers",
    "db_sdlc_scientist"
  ]
}
dns_name = "dev.cliniciannexus.com"
technical_groups = [
  "db_sdlc_engineer",
  "db_sdlc_mpt_developers",
  "db_sdlc_scientist"
]
azure_app_roles = {
  "User" = {
    description  = "User"
    display_name = "User"
    value        = ""

  },
  "msiam_access" = {
    description  = "msiam_access"
    display_name = "msiam_access"
    value        = ""

  },
}
