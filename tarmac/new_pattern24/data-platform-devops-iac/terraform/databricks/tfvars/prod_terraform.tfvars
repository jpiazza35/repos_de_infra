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
    "db_prod_ws_survey_analyst",
    "db_prod_data_platform_engineers"
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
  "db_prod_ws_engineer",
  "db_prod_mpt_developers",
  "db_prod_ws_scientist",
  "db_prod_data_platform_engineers"
]

enable_secondary_cidr = true
vpc_parameters = {
  max_subnet_count = 3
  networking = {
    secondary_cidr_block = "10.202.60.0/22" #"100.60.0.0/16"
  }
}
fivetran_vpce_id = "df9c9be0-4841-415b-b023-a8cad80428be"