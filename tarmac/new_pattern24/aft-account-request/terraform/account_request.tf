module "account" {
  source   = "./modules/aft-account-request"
  for_each = var.acct_config

  control_tower_parameters = {
    AccountEmail = format("AWS-%s-ROOT@sullivancotter.com", each.value.account_name)
    AccountName  = each.value.account_name
    # Syntax for top-level OU
    /* ManagedOrganizationalUnit = "Workloads" */
    # Syntax for nested OU
    ManagedOrganizationalUnit = each.value.ou
    SSOUserEmail              = "devops@cliniciannexus.com"
    SSOUserFirstName          = "DevOps"
    SSOUserLastName           = "ClinicianNexus"
  }

  account_tags = {
    "Team"        = each.value.team
    "Environment" = each.value.environment
  }

  change_management_parameters = {
    change_requested_by = each.value.requested_by
    change_reason       = each.value.account_description
  }

  custom_fields = {
    account_name          = each.value.account_name
    vpc_cidr_block        = each.value.create_vpc == "true" ? each.value.vpc_cidr_block : "null"
    environment           = each.value.environment
    create_vpc            = each.value.create_vpc
    enable_public_subnets = each.value.enable_public_subnets
    create_secondary_cidr = each.value.create_secondary_cidr
    region                = each.value.region
  }

  account_customizations_name = "configuration"

}
