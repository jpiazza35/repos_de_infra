module "databricks_workspaces" {
  source = "./modules/workspaces"
  providers = {
    aws.ss_network = aws.ss_network
    aws            = aws
    azuread        = azuread
  }
  databricks_account_id = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["account_id"]
  databricks_username   = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["username"]
  databricks_password   = jsondecode(data.aws_secretsmanager_secret_version.databricks[0].secret_string)["password"]
  account_id            = data.aws_caller_identity.current[*].account_id
  vpc_id                = data.aws_vpc.selected.id
  private_subnet_ids    = local.private_subnet_ids_az
  local_subnet_ids      = local.local_subnet_ids_az
  security_group_ids    = data.aws_security_groups.private[*].ids
  region                = var.region
  vpc_cidr              = local.vpc_cidr
  ss_network_vpc_ids    = data.aws_vpc.ss_network[*].id
  groups                = var.groups
  azure_app_roles       = var.azure_app_roles
  dns_name              = var.dns_name
  fivetran_vpce_id      = var.fivetran_vpce_id
  tags = {
    Environment = var.env
    App         = var.app
    Resource    = "Managed by Terraform"
    Description = "IAM BeyondInsight"
    Team        = "Data Platform"
  }
  env              = var.env
  app              = var.app
  technical_groups = var.technical_groups
}
