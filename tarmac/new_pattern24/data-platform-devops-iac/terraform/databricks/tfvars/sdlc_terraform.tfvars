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
    "db_sdlc_scientist",
    "db_sdlc_benchmark_developers",
    "db_sdlc_data_platform_engineers"
  ]
}
dns_name = "dev.cliniciannexus.com"
technical_groups = [
  "db_sdlc_engineer",
  "db_sdlc_mpt_developers",
  "db_sdlc_scientist",
  "db_sdlc_benchmark_developers",
  "db_sdlc_data_platform_engineers"
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

enable_secondary_cidr = true
vpc_parameters = {
  max_subnet_count = 3
  networking = {
    secondary_cidr_block = "10.202.64.0/22" #"100.60.0.0/16"
  }
}
fivetran_vpce_id = "df9c9be0-4841-415b-b023-a8cad80428be"
