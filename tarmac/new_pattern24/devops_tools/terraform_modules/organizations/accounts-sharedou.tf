resource "aws_organizations_account" "example-account_infra_code" {
  name      = "example-account-infra-code"
  email     = "example-account-aws+infracode@example-account.ch"
  parent_id = aws_organizations_organizational_unit.shared.id
}

resource "aws_organizations_account" "example-account_networking" {
  name      = "example-account-networking"
  email     = "example-account-aws+networking@example-account.ch"
  parent_id = aws_organizations_organizational_unit.shared.id
}

resource "aws_organizations_account" "example-account_shared_services" {
  name      = "example-account-shared-services"
  email     = "example-account-aws+sharedservices@example-account.ch"
  parent_id = aws_organizations_organizational_unit.shared.id
}