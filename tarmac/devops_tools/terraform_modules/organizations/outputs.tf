output "org_id" {
  value = aws_organizations_organization.root.id
}

output "product_ou_id" {
  value = aws_organizations_organizational_unit.product.id
}