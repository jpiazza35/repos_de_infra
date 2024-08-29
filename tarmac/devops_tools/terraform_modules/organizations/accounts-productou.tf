resource "aws_organizations_account" "example-account_proxy_dev" {
  name      = "example-account-proxy-dev"
  email     = "example-account-aws+proxy-dev@example-account.ch"
  parent_id = aws_organizations_organizational_unit.product.id
}

resource "aws_organizations_account" "example-account_proxy_test" {
  name      = "example-account-proxy-test"
  email     = "example-account-aws+proxy-test@example-account.ch"
  parent_id = aws_organizations_organizational_unit.product.id
}

resource "aws_organizations_account" "example-account_proxy_prod" {
  name      = "example-account-proxy-prod"
  email     = "example-account-aws+proxy-prod@example-account.ch"
  parent_id = aws_organizations_organizational_unit.product.id
}