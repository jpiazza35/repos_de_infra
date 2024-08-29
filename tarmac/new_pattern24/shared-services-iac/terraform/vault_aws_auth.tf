module "d_data_platform_aws_auth" {
  source = "./modules/vault_aws_auth"
  providers = {
    aws.source = aws
    aws.target = aws.d_data_platform
  }
  create_aws_auth = true
}


module "p_data_platform_aws_auth" {
  source = "./modules/vault_aws_auth"
  providers = {
    aws.source = aws
    aws.target = aws.p_data_platform
  }
  create_aws_auth = true
}
