locals {
  sdlc_eks_accounts = [
    for account in var.eks_aws_account_ids : account.account_id
    if account.name != "P_EKS" && terraform.workspace == "sdlc"
  ]

  prod_eks_account = var.eks_aws_account_ids["prod"].account_id

}
