data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_organizations_organization" "current" {}

data "vault_generic_secret" "phpipam" {
  path = "devops/phpipam"
}

data "phpipam_section" "sc" {
  name = "SullivanCotter"
}

## VPC CIDR for account /23
data "phpipam_subnets" "nova" {
  count       = terraform.workspace == "tgw" ? 1 : 0
  section_id  = data.phpipam_section.sc.id
  description = var.aws_account_name
}

## phpIPAM Subnet IDs
data "phpipam_subnet" "subnets" {
  count     = terraform.workspace == "tgw" ? length(data.phpipam_subnets.nova[0].subnet_ids) : 0
  subnet_id = element(data.phpipam_subnets.nova[0].subnet_ids, count.index)
}

## Region CIDR /16
data "phpipam_subnet" "ohio" {
  count             = data.aws_region.current.name == "us-east-2" ? 1 : 0
  section_id        = data.phpipam_section.sc.id
  description_match = upper(data.aws_region.current.name)
}

## Region CIDR /16
data "phpipam_subnet" "nova" {
  count             = terraform.workspace == "tgw" ? 1 : 0
  section_id        = data.phpipam_section.sc.id
  description_match = "US-EAST-2"
}

data "aws_networkmanager_global_networks" "main" {
  provider = aws.use1
}

data "aws_dx_gateway" "dxgw" {
  provider = aws.use1
  name     = "cn-qts-chicago-dxgw"
}
