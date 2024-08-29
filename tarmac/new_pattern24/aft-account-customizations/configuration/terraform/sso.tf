module "sso" {
  source = "./modules/sso"
  providers = {
    aws = aws.ct-management
  }
  sso        = var.sso
  account_id = data.aws_caller_identity.current.account_id
}
