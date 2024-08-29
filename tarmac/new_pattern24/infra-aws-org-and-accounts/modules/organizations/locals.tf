locals {
  accounts = csvdecode(templatefile("${path.module}/control-tower-accounts.csv",
    {
      dev_accounts_org_unit = var.dev_accounts_org_unit
    }
  ))
}