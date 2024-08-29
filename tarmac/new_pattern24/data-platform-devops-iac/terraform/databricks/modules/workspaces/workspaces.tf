resource "random_string" "naming" {

  special = false
  upper   = false
  length  = 6
}

// Properly configure the cross-account role for the creation of new workspaces within your AWS account.
resource "databricks_mws_credentials" "creds" {

  provider         = databricks.mws
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = var.env != "prod" ? format("cn-%s-creds", local.prefix) : format("%s-creds", local.prefix)
  depends_on = [
    aws_iam_role_policy.cross_account_policy
  ]
}

// Configure VPC for databricks
resource "databricks_mws_networks" "network" {

  provider     = databricks.mws
  account_id   = var.databricks_account_id
  network_name = format("cn-%s-network", local.prefix)
  security_group_ids = [
    aws_security_group.databricks_private_link.id
  ]
  subnet_ids = var.local_subnet_ids
  # concat(
  #   [var.private_subnet_ids[0]],
  #   [var.private_subnet_ids[2]],
  #   [var.local_subnet_ids[1]]
  # )
  vpc_id = var.vpc_id
  vpc_endpoints {
    dataplane_relay = [
      databricks_mws_vpc_endpoint.relay.vpc_endpoint_id
    ]
    rest_api = [
      databricks_mws_vpc_endpoint.workspace.vpc_endpoint_id
    ]

  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }
}

// Configure CMK for Workspace
resource "databricks_mws_customer_managed_keys" "storage_and_managed_services" {

  provider   = databricks.mws
  account_id = var.databricks_account_id
  aws_key_info {
    key_arn   = aws_kms_key.customer_managed_key.arn
    key_alias = aws_kms_alias.customer_managed_key_alias.name
  }
  use_cases = [
    "STORAGE",
    "MANAGED_SERVICES"
  ]
}

// Configure the S3 root bucket within your AWS account for new Databricks workspaces.
resource "databricks_mws_storage_configurations" "db_storage_configs" {

  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  bucket_name                = aws_s3_bucket.root_storage_bucket.bucket
  storage_configuration_name = var.env != "prod" ? format("cn-%s-storage", local.prefix) : format("%s-storage", local.prefix)
}

// Configure VPC Endpoints
resource "databricks_mws_vpc_endpoint" "workspace" {

  provider            = databricks.mws
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.workspace.id
  vpc_endpoint_name   = "VPC Workspace Endpoint for ${var.vpc_id}"
  region              = var.region
  depends_on = [
    aws_vpc_endpoint.workspace
  ]
}

resource "databricks_mws_vpc_endpoint" "relay" {

  provider            = databricks.mws
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.relay.id
  vpc_endpoint_name   = "VPC Relay for ${var.vpc_id}"
  region              = var.region
  depends_on = [
    aws_vpc_endpoint.relay
  ]
}

// Configure Private Access Settings
resource "databricks_mws_private_access_settings" "pas" {

  provider = databricks.mws
  # account_id                   = var.databricks_account_id
  private_access_settings_name = "Private Access Settings for ${local.prefix}"
  region                       = var.region
  public_access_enabled        = false
  private_access_level         = "ENDPOINT" #"ACCOUNT"
  allowed_vpc_endpoint_ids = [
    databricks_mws_vpc_endpoint.workspace.vpc_endpoint_id,
    var.fivetran_vpce_id
  ]
  depends_on = [
    aws_route53_zone.private,
  ]
}

// Set up the Databricks workspace to use the E2 version of the Databricks on AWS platform.
resource "databricks_mws_workspaces" "workspace" {

  provider        = databricks.mws
  account_id      = var.databricks_account_id
  aws_region      = var.region
  workspace_name  = local.prefix
  deployment_name = local.prefix

  credentials_id                           = databricks_mws_credentials.creds.credentials_id
  storage_configuration_id                 = databricks_mws_storage_configurations.db_storage_configs.storage_configuration_id
  network_id                               = databricks_mws_networks.network.network_id
  private_access_settings_id               = databricks_mws_private_access_settings.pas.private_access_settings_id
  storage_customer_managed_key_id          = databricks_mws_customer_managed_keys.storage_and_managed_services.customer_managed_key_id
  managed_services_customer_managed_key_id = databricks_mws_customer_managed_keys.storage_and_managed_services.customer_managed_key_id

  token {
    comment = "Terraform"
  }

  timeouts {
    create = "30m"
    read   = "10m"
    update = "20m"
  }
}

// Create a Databricks personal access token, to provision entities within the workspace.
# resource "databricks_token" "pat" {

#   provider         = databricks.mws
#   comment          = "Managed by Terraform"
#   lifetime_seconds = 86400
# }
