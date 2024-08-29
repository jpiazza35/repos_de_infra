data "aws_vpc" "vpc" {
  id = var.common_properties.vpc_id
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.common_properties.vpc_id]
  }

  tags = {
    Layer = "private"
  }
}

data "aws_caller_identity" "current" {}

# Secrets from Vault
data "vault_generic_secret" "prod-ces-db" {
  path = "data_platform/prod/databricks/ces"
}

data "vault_generic_secret" "prod-incumbent-db" {
  path = "data_platform/prod/mpt/psql_incumbent"
}

data "vault_generic_secret" "prod-mssql-db" {
  path = "data_platform/prod/databricks/sql_server"
}

data "vault_generic_secret" "dataworld-rw-api-token" {
  path = "data_platform/dev/datadotworld"
}

data "vault_generic_secret" "prod-tableau" {
  path = "data_platform/prod/tableau"
}

data "vault_generic_secret" "prod-redshift" {
  path = "data_platform/prod/dataworld_rs_edw"
}

data "vault_generic_secret" "nonprod-databricks" {
  path = "data_platform/nonprod/databricks/datadotworld"
}

data "vault_generic_secret" "slack_webhook" {
  path = "devops/datadotworld/slack"
}
