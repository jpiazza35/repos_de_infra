resource "aws_organizations_account" "dtcloud_logging_monitoring" {
  name      = "dtcloud-logging-monitoring"
  email     = "dtcloud-aws+logging@datatrans.ch"
  parent_id = aws_organizations_organizational_unit.core.id
}

resource "aws_organizations_account" "dtcloud_security" {
  name      = "dtcloud-security"
  email     = "dtcloud-aws+security@datatrans.ch"
  parent_id = aws_organizations_organizational_unit.core.id
}

resource "aws_organizations_account" "dtcloud_master" {
  name      = "dtcloud master"
  email     = "dominic.ruettimann@datatrans.ch"
  parent_id = aws_organizations_organization.root.roots[0].id
}