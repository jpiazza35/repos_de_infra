resource "aws_organizations_organizational_unit" "core" {
  name      = "Core"
  parent_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_organizational_unit" "product" {
  name      = "Product"
  parent_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_organizational_unit" "shared" {
  name      = "Shared"
  parent_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_organizational_unit" "planet_sandbox_tgw" {
  name      = "planet-sandbox-tgw"
  parent_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_organizational_unit" "planet_sandbox_cloud" {
  name      = "planet-sandbox-cloud"
  parent_id = aws_organizations_organization.root.roots[0].id
}