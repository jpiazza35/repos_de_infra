locals {
  account_assignments = [
    {
      principal_name = "DevAdminGroup"
      principal_type = "GROUP"
      permission_set = var.admin_pset_name
      account_id     = var.dev_acc_id
    },
    {
      principal_name = "DevReadOnlyGroup"
      principal_type = "GROUP"
      permission_set = var.readonly_pset_name
      account_id     = var.dev_acc_id
    },
    {
      principal_name = "DevBillingGroup"
      principal_type = "GROUP"
      permission_set = var.billing_pset_name
      account_id     = var.dev_acc_id
    },
    {
      principal_name = "ProdAdminGroup"
      principal_type = "GROUP"
      permission_set = var.admin_pset_name
      account_id     = var.prod_acc_id
    },
    {
      principal_name = "ProdReadOnlyGroup"
      principal_type = "GROUP"
      permission_set = var.readonly_pset_name
      account_id     = var.prod_acc_id
    },
    {
      principal_name = "ProdBillingGroup"
      principal_type = "GROUP"
      permission_set = var.billing_pset_name
      account_id     = var.prod_acc_id
    },
  ]
}