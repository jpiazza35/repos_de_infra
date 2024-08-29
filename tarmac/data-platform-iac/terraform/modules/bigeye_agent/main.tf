module "bigeye_ec2" {
  source        = "../ec2"
  vpc           = data.aws_vpc.vpc
  app           = "bigeye-databricks"
  instance_type = "t3.xlarge"
  ami_id        = data.aws_ami.ami.id
  subnet_id     = data.aws_subnets.private.ids[0]
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    tf_var_account_id               = data.aws_caller_identity.current.account_id
    bigeye_mtls_secret_name         = var.mtls_secret_name
    bigeye_agent_config_secret_name = var.agent_config_secret_name
    agent_identifier                = var.agent_identifier
    agent_type                      = var.agent_type
  }))
  iam_instance_profile = data.aws_iam_instance_profile.instance_profile.name
  env                  = var.env
}
