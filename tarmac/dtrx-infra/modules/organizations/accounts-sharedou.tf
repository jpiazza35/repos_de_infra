resource "aws_organizations_account" "dtcloud_infra_code" {
  name      = "dtcloud-infra-code"
  email     = "dtcloud-aws+infracode@datatrans.ch"
  parent_id = aws_organizations_organizational_unit.shared.id
}

resource "aws_organizations_account" "dtcloud_networking" {
  name      = "dtcloud-networking"
  email     = "dtcloud-aws+networking@datatrans.ch"
  parent_id = aws_organizations_organizational_unit.shared.id
}

resource "aws_organizations_account" "dtcloud_shared_services" {
  name      = "dtcloud-shared-services"
  email     = "dtcloud-aws+sharedservices@datatrans.ch"
  parent_id = aws_organizations_organizational_unit.shared.id
}