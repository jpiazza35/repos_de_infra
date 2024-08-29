aws_acct_name = "S_DATABRICKS"
region        = "us-east-1"
env           = "preview"
app           = "databricks"
groups = {
  admins = [
    "db_preview_admin",
    "db_all_workspaces_admins"
  ]
  users = [
    "db_preview_engineer",
    "db_preview_sandbox",
    "db_preview_mpt_developers",
    "db_preview_user",
    "db_preview_bi",
    "db_preview_scientist",
    "db_preview_survey_analyst"
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
  "db_preview_engineer",
  "db_preview_mpt_developers",
  "db_preview_scientist"
]

enable_secondary_cidr = true
vpc_parameters = {
  max_subnet_count = 3
  networking = {
    secondary_cidr_block = "10.202.56.0/22" #"100.60.0.0/16"
  }
}
fivetran_vpce_id = "df9c9be0-4841-415b-b023-a8cad80428be"