locals {

  ## VPC CIDR from account request data
  primary_cidr = jsondecode(
    jsondecode(
    data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).vpc_cidr_block != "null" && jsondecode(
    jsondecode(
    data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).vpc_cidr_block != "" ? jsondecode(
    jsondecode(
  data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).vpc_cidr_block : null

  ## Environment from account request data
  environment = jsondecode(
    jsondecode(
  data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).environment

  ## Create VPC flag from account request data
  create_vpc = try(
    jsondecode(
      jsondecode(
    data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).create_vpc, false
  )

  ## Account Name from account request data
  account_name = jsondecode(
    jsondecode(
  data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).account_name

  ## Enable public subnets flag from account request data
  enable_public_subnets = try(
    jsondecode(
      jsondecode(
    data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).enable_public_subnets, false
  )

  ## Should the secondary VPC Cidr be created
  create_secondary_cidr = try(
    jsondecode(
      jsondecode(
    data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).create_secondary_cidr, false
  )

  ## Region to create resources in
  region = jsondecode(
    jsondecode(
    data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).region != "null" && jsondecode(
    jsondecode(
    data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).region != "" ? jsondecode(
    jsondecode(
  data.aws_dynamodb_table_item.acct_request.item).custom_fields.S).region : "us-east-2"

}
