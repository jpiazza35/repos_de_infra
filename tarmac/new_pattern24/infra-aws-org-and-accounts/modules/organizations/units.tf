resource "aws_organizations_organizational_unit" "individuals" {
  name      = var.dev_accounts_org_unit
  parent_id = data.aws_organizations_organization.clinician_nexus.roots[0].id
}
