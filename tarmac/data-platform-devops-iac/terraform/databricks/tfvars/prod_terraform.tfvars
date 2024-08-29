aws_acct_name = "P_DATABRICKS"
region        = "us-east-1"
env           = "prod"
app           = "databricks"
groups = {
  admins = [
    "db_prod_ws_admin",
    "db_all_workspaces_admins"
  ]
  users = [
    "db_prod_ws_engineer",
    "db_prod_ws_sandbox",
    "db_prod_mpt_developers",
    "db_prod_ws_user",
    "db_prod_ws_bi",
    "db_prod_ws_scientist",
    "db_prod_ws_survey_analyst"
  ]
}
dns_name = "dev.cliniciannexus.com"
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
technical_groups = [
  "db_prod_engineer",
  "db_prod_mpt_developers",
  "db_prod_scientist"
]
