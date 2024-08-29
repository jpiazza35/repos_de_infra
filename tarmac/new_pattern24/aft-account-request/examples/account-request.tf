module "sandbox_account_01" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail = "AWS-sandbox-account-01-Root@sullivancotter.com"
    AccountName  = "sandbox-account-01"
    # Syntax for top-level OU
    ManagedOrganizationalUnit = "Sandbox"
    # Syntax for nested OU
    # ManagedOrganizationalUnit = "Sandbox (ou-xfe5-a8hb8ml8)"
    SSOUserEmail     = "john.doe@cliniciannexus.com"
    SSOUserFirstName = "John"
    SSOUserLastName  = "Doe"
  }

  account_tags = {
    "ABC:Owner"       = "john.doe@cliniciannexus.com"
    "ABC:Division"    = "ENT"
    "ABC:Environment" = "Dev"
    "ABC:CostCenter"  = "123456"
    "ABC:Vended"      = "true"
    "ABC:DivCode"     = "102"
    "ABC:BUCode"      = "ABC003"
    "ABC:Project"     = "123456"
  }

  change_management_parameters = {
    change_requested_by = "John Doe"
    change_reason       = "testing the account vending process"
  }

  custom_fields = {
    account_name   = "sandbox-account-01"
    vpc_cidr_block = "10.0.0.0/16"
  }

  account_customizations_name = "configuration"
}
