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