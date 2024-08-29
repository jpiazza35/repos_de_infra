data "aws_caller_identity" "current" {
  provider = aws.use1
}

data "aws_region" "current" {}

data "aws_organizations_organization" "current" {}

# Get the account ID of the AWS Account designated as the primary admin account to run cross account terraform (i.e. SS_TOOLS)
data "aws_ssm_parameter" "org_admin_account" {
  provider = aws.aft-management

  name = "/aft/resources/iam/organization_admin_account"
}

# Get the DyanmoDB table that holds the AFT account request data
data "aws_ssm_parameter" "dyanmodb_aft_request_table" {
  provider = aws.aft-management

  name = "/aft/resources/ddb/aft-request-table-name"
}

# Get the DyanmoDB table that holds the AFT account request metadata
data "aws_ssm_parameter" "dyanmodb_aft_request_metadata_table" {
  provider = aws.aft-management

  name = "/aft/resources/ddb/aft-request-metadata-table-name"
}

# Get the email ID of the account from the metadata table
data "aws_dynamodb_table_item" "acct_metadata" {
  provider = aws.aft-management

  table_name = data.aws_ssm_parameter.dyanmodb_aft_request_metadata_table.value
  key        = <<KEY
    {
      "id": {"S": "${data.aws_caller_identity.current.account_id}"}
    }
  KEY
}

# Get the account request data
data "aws_dynamodb_table_item" "acct_request" {
  provider = aws.aft-management

  table_name = data.aws_ssm_parameter.dyanmodb_aft_request_table.value
  key        = <<KEY
    {
      "id": {"S": "${jsondecode(data.aws_dynamodb_table_item.acct_metadata.item).email.S}"}
    }
  KEY
}

data "aws_secretsmanager_secret" "secret" {
  name     = "phpIPAM"
  provider = aws.aft-management
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.secret.id
  provider  = aws.aft-management
}

data "phpipam_section" "sc" {
  name = "SullivanCotter"
}

data "phpipam_subnet" "supernet" {
  count             = data.aws_region.current.name == "us-east-1" ? 1 : 0
  section_id        = data.phpipam_section.sc.id
  description_match = upper(data.aws_region.current.name)
}

data "phpipam_subnet" "ohio" {
  count             = data.aws_region.current.name == "us-east-2" ? 1 : 0
  section_id        = data.phpipam_section.sc.id
  description_match = upper(data.aws_region.current.name)
}


data "phpipam_subnet" "nova" {
  /* count             = terraform.workspace == "tgw" ? 1 : 0 */
  section_id        = data.phpipam_section.sc.id
  description_match = "US-EAST-2" #upper(data.aws_region.current.name)
}
